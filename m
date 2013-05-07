Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3EGQFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:05:46 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50003 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3EGQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <5189252C.20201@zytor.com>
References: <1367942305-32748-1-git-send-email-syed.salman.mansoor@gmail.com>
	<5189252C.20201@zytor.com>
Date: Tue, 7 May 2013 21:05:44 +0500
Message-ID: <CANymLzUrwFwAEoiW1Ry3wp=FbtJxc+buURWqdgKtPdOWKsdu4g@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: Cleanup A20 Code
From: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Thanks but actually I wanted to get idea how to create kernel
patch and how to use GIT. So now will try to  focus on actual fix.
Anyways sorry for any inconvenience occured due to whitespace
messaging patch.

Thanks a lot again.

On Tue, May 7, 2013 at 9:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/07/2013 08:58 AM, Syed Salman Mansoor wrote:
>> Fix checkpatch.pl warnings in a20.c
>> i)  WARNING: please, no spaces at the start of a line
>> ii) WARNING: suspect code indent for conditional statements
>> iii) ERROR: trailing whitespace
>
> This patch doesn't actually change anything meaningful.  Sorry,
> "whitespace massaging" patches are generally considered pure nuisance.
>
>         -hpa
>
