Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3IYDHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:07:30 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:60959 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3IYDH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPf+udamAfuaR4OQD1RrAQ99iREAXxYPAWUi3Ghx_=xDQ@mail.gmail.com>
References: <1380058748-9347-1-git-send-email-bleung@chromium.org>
	<CACVXFVPf+udamAfuaR4OQD1RrAQ99iREAXxYPAWUi3Ghx_=xDQ@mail.gmail.com>
Date: Tue, 24 Sep 2013 20:07:25 -0700
X-Google-Sender-Auth: 0l6sC4lWQTwIbE85HbNHjbkvgAE
Message-ID: <CANLzEksBhzPOg8Tfax-J0sy5VBgEqCyz9sgjOiNSvTR=WeybBA@mail.gmail.com>
Subject: Re: [PATCH] driver core : Fix use after free of dev->parent in device_shutdown
From: Benson Leung <bleung@chromium.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 6:14 PM, Ming Lei <ming.lei@canonical.com> wrote:
> It is better to save one line by below:
>
>                     parent = get_device(dev->parent);
>
Done.

>
> Reviewed-by: Ming Lei <ming.lei@canonical.com>

Thank you!


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
