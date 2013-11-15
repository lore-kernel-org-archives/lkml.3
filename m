Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3KOK0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:26:53 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34390 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3KOK0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:26:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131115041730.GA539@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-8-git-send-email-bergwolf@gmail.com> <20131115041730.GA539@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 15 Nov 2013 18:26:21 +0800
Message-ID: <CA+a=Yy6EGD5bF=yUYoC9tfP2fWoofa_FOOmRbDLdzbN8Qn_vqw@mail.gmail.com>
Subject: Re: [PATCH 07/40] staging/lustre/hsm: Implementation of exclusive open
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:17 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 15, 2013 at 12:13:09AM +0800, Peng Tao wrote:
>> From: Jinshan Xiong <jinshan.xiong@intel.com>
>>
>> In this patch, a framework of lease is implemented. However,
>> only exclusive lease is supported right now.
>
> Which is a problem, why?
>
> Why do you want to add this new functionality?  What is it good for?
> Who will use it?
>
Only brief info for the patch in included in the commit message. The
long story is saved in the external link
https://jira.hpdd.intel.com/browse/LU-2919. I guess I need to pull
more bits to the commit message to make it more understandable.

> Oh, and the patch doesn't apply to my tree, AND it contains a bunch of
> foolish coding style errors, so even if I did understand what this was
> for, and why we wanted it, I couldn't.
>
I'll fix up. sorry.

Thanks,
Tao
