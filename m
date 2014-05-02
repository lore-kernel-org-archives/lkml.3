Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEBFiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:38:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaEBFiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:38:51 -0400
Message-ID: <53632F50.9010506@zytor.com>
Date: Thu, 01 May 2014 22:38:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove __visible from asmlinkage for 3.15
References: <1398984278-29319-1-git-send-email-andi@firstfloor.org> <CA+55aFwc5znv-mqSX9nwVWNoXRUekoTiia4vgLgxauQcVZD15w@mail.gmail.com>
In-Reply-To: <CA+55aFwc5znv-mqSX9nwVWNoXRUekoTiia4vgLgxauQcVZD15w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 05:52 PM, Linus Torvalds wrote:
> On Thu, May 1, 2014 at 3:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> This is the earlier patchkit based on Linus original feedback.
>> It should be merged for 3.15 to finally quell the asmlinkage warnings
>> that are visible in various configurations.
> 
> Ack, looks good to me. I'm assuming I'll get this through the -tip
> tree, otherwise holler and I'll pick it up directly, but it's not like
> there is any major hurry.
> 

How about I put it into tip/urgent, but for next week's pull so it gets
some time to cook first...

	-hpa


