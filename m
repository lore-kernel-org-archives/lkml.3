Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3HJEnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 00:43:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57134 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3HJEne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 00:43:34 -0400
Message-ID: <5205C4BB.6020003@zytor.com>
Date: Fri, 09 Aug 2013 21:42:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 04:04 PM, Andi Kleen wrote:
> 
> This patch kit is an attempt to get us back to sane code, 
> mostly by doing proper inlining and doing sleep checks in the right
> place. Unfortunately I had to add one tree sweep to avoid an nasty
> include loop.
> 
> It costs a bit of text space, but I think it's worth it
> (if only to keep my blood pressure down while reading ftrace logs...)
> 

Looks nice at first glance.

Now, here is a bigger question: shouldn't we be deprecating/getting rid
of PREEMPT_VOUNTARY in favor of PREEMPT?

	-hpa


