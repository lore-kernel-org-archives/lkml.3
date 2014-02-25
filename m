Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBYEgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:36:45 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37116 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaBYEgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:36:44 -0500
MIME-Version: 1.0
In-Reply-To: <1393301264-5228-1-git-send-email-linux@roeck-us.net>
References: <1393301264-5228-1-git-send-email-linux@roeck-us.net>
Date: Tue, 25 Feb 2014 08:36:43 +0400
Message-ID: <CAMo8BfKBY8BsveZEnodP6HeM6yjv1G2n-=Hnf=jf1-Nnt=DeTg@mail.gmail.com>
Subject: Re: [PATCH] xtensa: export ccount_freq
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 8:07 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> xtensa:allmodconfig fails to build with hundreds of messages such as
>
> ERROR: "ccount_freq" [drivers/ata/pata_hpt3x2n.ko] undefined!
>
> Exporting ccount_freq solves the problem.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/xtensa/kernel/time.c |    1 +
>  1 file changed, 1 insertion(+)

Hi Guenter,

a similar patch is already queued:
http://lists.linux-xtensa.org/pipermail/linux-xtensa/Week-of-Mon-20140113/001500.html

-- 
Thanks.
-- Max
