Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaFLSlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:41:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:33786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaFLSlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="354295591"
Message-ID: <5399F445.6060200@linux.intel.com>
Date: Thu, 12 Jun 2014 11:41:09 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Kui Zhang <kuizhang@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Segmentation fault on all golang executables
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com> <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com> <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com>
In-Reply-To: <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:38 AM, Andy Lutomirski wrote:
>>
>> 2. Write a dummy section table that contains a single empty section of
>> type SHT_DYNSYM.  Hopefully the Go runtime will then get far enough to
>> fail cleanly.  And they can go and write a real ELF parser or copy my
>> reference parser correctly.  (hpa, can you apply my patches to make
>> the reference parser 32-bit clean?)
> 

Could you resend it please?

> Sigh.
> 
> See attached.  It seems to work for me.  Can you test it?  It'll hurt
> performance for Go programs, but I don't feel too bad about that.
> 

If Google fixes Go, will that address the performance problem?

	-hpa


