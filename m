Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3IWPrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:47:37 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52898 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3IWPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_sVSo04e4Su0sUm7h7wgM6xP=XVb+sWFT-e-VZP7FJXQ@mail.gmail.com>
References: <CAPgLHd_sVSo04e4Su0sUm7h7wgM6xP=XVb+sWFT-e-VZP7FJXQ@mail.gmail.com>
Date: Mon, 23 Sep 2013 08:47:33 -0700
X-Google-Sender-Auth: wnzTGklDrnsE2TJNzHc2S7YR0ys
Message-ID: <CAGXu5jK9j8LT-1+iCFL84fEErOnheLdRQMzcouqkeHBhQEo-uQ@mail.gmail.com>
Subject: Re: [PATCH] i2o: add missing destroy_workqueue() on error in i2o_driver_register()
From: Kees Cook <keescook@chromium.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, yongjun_wei@trendmicro.com.cn,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 2:56 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing destroy_workqueue() before return from
> i2o_driver_register() in the error handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Good catch!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
