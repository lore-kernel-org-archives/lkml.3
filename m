Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaKEJWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:22:09 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56995 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaKEJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:21:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAOD=uF4L+jvR=ckMdo3o4wdSsRcGynQnv_KOpDeyJst74YOxuA@mail.gmail.com>
References: <CAOD=uF4L+jvR=ckMdo3o4wdSsRcGynQnv_KOpDeyJst74YOxuA@mail.gmail.com>
Date: Wed, 5 Nov 2014 10:14:37 +0100
Message-ID: <CAFLxGvywuEox+2fYZ-+ZLop=Za7Kum8P+q1kHx3cFWF2nG6O5A@mail.gmail.com>
Subject: Re: How to access Linux Kernel environment Variables ?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 9:03 AM, santosh prasad nayak
<santoshprasadnayak@gmail.com> wrote:
> Hi all,
>
> Is there any system call in Linux which serve the purpose of  "kenv()"
> of FreeBSD ?
>
>
> In FreeBSD:
> -----------------
> Kernel environment variables are saved at "/boot/loader.conf"  and
> those variables can be accessed using "kenv()"  system call in C
> program.
> ----------------
>
>
> Is there any similar functionality available in Linux kernel ?

/proc/cmdline?

-- 
Thanks,
//richard
