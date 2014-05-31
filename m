Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984AbaEaAPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:15:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbaEaAPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:15:17 -0400
Message-ID: <53891F02.50702@zytor.com>
Date: Fri, 30 May 2014 17:14:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] x86,vdso: Fix cross-compilation from big-endian
 architectures
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com> <cover.1401464755.git.luto@amacapital.net> <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net> <5388E3EF.6030700@zytor.com> <CALCETrVvR3SaYX7jvoX_q7m=HSzt1xvrDurrOpm2XT5SG3JVqw@mail.gmail.com> <5388E83A.5000500@zytor.com> <CALCETrWgfRiknJTQtDSAavF1695NDy-h-DW1big+65-HmEOtwg@mail.gmail.com>
In-Reply-To: <CALCETrWgfRiknJTQtDSAavF1695NDy-h-DW1big+65-HmEOtwg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:34 PM, Andy Lutomirski wrote:
>>
>> GET_LE() then?
> 
> Sounds good.
> 
> Are you planning on writing the patch?
> 
> I think my v2 is good -- the only diff I could find in my image.c
> files and Stephen's was in the alt_xyz output, and I think I fixed
> that in v2.
> 

Build testing one now.

	-hpa

