Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFLSt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:49:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:60501 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaFLStZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:49:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="354297971"
Message-ID: <5399F616.2040809@linux.intel.com>
Date: Thu, 12 Jun 2014 11:48:54 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Segmentation fault on all golang executables
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com> <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com> <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com> <5399F445.6060200@linux.intel.com> <CALCETrV96Ry5f_RDvXfZ98ay9qLZw0-8H5LZ8NrPiS92WDWTmA@mail.gmail.com>
In-Reply-To: <CALCETrV96Ry5f_RDvXfZ98ay9qLZw0-8H5LZ8NrPiS92WDWTmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:42 AM, Andy Lutomirski wrote:
> 
> Note that my hack will build a buggy vdso on big-endian hosts.  Is
> there a way to convert host -> BE yet?
> 

Yes, use <tools/be_byteshift.h>.

	-hpa


