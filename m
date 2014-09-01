Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaIAQfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:35:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55020 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaIAQfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:35:40 -0400
Message-ID: <5404A035.3070707@zytor.com>
Date: Mon, 01 Sep 2014 09:35:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
References: <20140809231911.GA4843@khazad-dum.debian.net> <20140831194548.GA12628@khazad-dum.debian.net> <54037C07.8060703@zytor.com> <20140831201126.GB12628@khazad-dum.debian.net> <20140901051302.GA28402@nazgul.tnic>
In-Reply-To: <20140901051302.GA28402@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2014 10:13 PM, Borislav Petkov wrote:
> On Sun, Aug 31, 2014 at 05:11:26PM -0300, Henrique de Moraes Holschuh wrote:
>>> Probably more like something more like arch/x86/boot/cmdline.c.  Maybe
>>> we could even make it sharable.
>>
>> Looks like that would work, yes.
> 
> Guys, guys, please relax and check the code first: "dis_ucode_ldr".
> 

Yeah.  It is an absolutely horrific option name (something like
"noearlyucode" would have been so much nicer; we generally use the no-
prefix and no underscores) but I should have objected to that one much
sooner.

	-hpa

