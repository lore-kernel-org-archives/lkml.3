Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3CNNZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:25:25 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:57856 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab3CNNZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:25:23 -0400
MIME-Version: 1.0
In-Reply-To: <1362736584-21115-1-git-send-email-erwan.yvin@stericsson.com>
References: <1362736584-21115-1-git-send-email-erwan.yvin@stericsson.com>
Date: Thu, 14 Mar 2013 14:25:23 +0100
Message-ID: <CACRpkdbj7uHwMSTgUzapRQUTJQaPB+c0A1t2DcAuQi7Tf9K2Pg@mail.gmail.com>
Subject: Re: [PATCH] caif: remove caif_shm
From: Linus Walleij <linus.walleij@linaro.org>
To: Erwan Yvin <erwan.yvin@stericsson.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Sjur Brendeland <sjur.brendeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 10:56 AM, Erwan Yvin <erwan.yvin@stericsson.com> wrote:

> caif_shm is an old implementation
> caif_shm will be replaced by caif_virtio
>
> Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>
> Acked-by: Sjur Brendeland <sjur.brandeland@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

The story is something like this: U5500 used this, but was cancelled
and the silicon did not reach anyone outside ST-Ericsson.

Then for the next platforms, we have gone for the leaner & cleaner
approach of using virtio, rpmesg and rproc.

This can be safely deleted.

Yours,
Linus Walleij
