Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaCHFPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:15:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42769 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbaCHFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:15:21 -0500
Message-ID: <531AA766.3050309@free-electrons.com>
Date: Sat, 08 Mar 2014 06:15:18 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>, dougthompson@xmission.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com> <20131014095602.GA14274@jtlinux> <5316B065.7070104@free-electrons.com> <20140305064915.GA28317@pd.tnic>
In-Reply-To: <20140305064915.GA28317@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 07:49 AM, Borislav Petkov wrote:
> On Wed, Mar 05, 2014 at 06:04:37AM +0100, Michael Opdenacker wrote:
>> My patch still applies to 3.14-rc5, which means that mpc85xx_edac is
>> still there.
>>
>> I'd like to get rid of this patch for good ;)
> Something like that, right:
>
> https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=e245e3b25f9ef33b166f0f01d19d6418f52ae726
>
> ?
>
> Its on its way upstream.
Great, thank you for the good news!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

