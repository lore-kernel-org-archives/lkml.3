Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaJAUSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:18:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37653 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbaJAUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:18:02 -0400
Message-ID: <542C6177.4030506@free-electrons.com>
Date: Wed, 01 Oct 2014 22:17:59 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>, dougthompson@xmission.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com> <20131014095602.GA14274@jtlinux> <5316B065.7070104@free-electrons.com> <20140305064915.GA28317@pd.tnic> <542BD4DC.40900@free-electrons.com> <20141001102701.GB18271@pd.tnic>
In-Reply-To: <20141001102701.GB18271@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 10/01/2014 12:27 PM, Borislav Petkov wrote:
> On Wed, Oct 01, 2014 at 12:18:04PM +0200, Michael Opdenacker wrote:
>>> https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=e245e3b25f9ef33b166f0f01d19d6418f52ae726
>>>
>>> ?
>>>
>>> Its on its way upstream.
>> It didn't get merged indeed.
> Did you actually check?
>
> $ git describe e245e3b25f9ef33b166f0f01d19d6418f52ae726
> v3.14-rc1-4-ge245e3b25f9e

Oops, you're right. What's left of my patch touches other files.

Thank you for your time.

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

