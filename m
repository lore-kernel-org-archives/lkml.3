Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaLAVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:03:56 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:59349 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaLAVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:03:53 -0500
MIME-Version: 1.0
In-Reply-To: <1417429031-4576-1-git-send-email-jeffrey.lin@rad-ic.com>
References: <1417429031-4576-1-git-send-email-jeffrey.lin@rad-ic.com>
Date: Mon, 1 Dec 2014 13:03:53 -0800
X-Google-Sender-Auth: qN_ZQ2aVfosL6VR-SW_AHMgWhmI
Message-ID: <CANLzEkshTf0ef-WWN64L55md4L+qsu0LTSR_KV1Ab8CVvgG9oA@mail.gmail.com>
Subject: Re: [PATCH] driver: input: touchscreen: add Raydium i2c touchscreen driver
From: Benson Leung <bleung@chromium.org>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, shc_work@mail.ru,
        lee.jones@linaro.org, charliemooney@chromium.org, KP.li@rad-ic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "jeffrey.lin" <jeffrey.lin@rad-ic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 2:17 AM, jeffrey.lin <yajohn@gmail.com> wrote:
> From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
>
> This patch is porting Raydium I2C touch driver. Developer can enable
> raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
>
> Change-Id: I5f33cfdf0e895de6e7d535c11dd4b3ce8b49fa48

Once again, please remove this bit of Gerrit change-id from your patch
submissions in the future.

> Signed-off-by: jeffrey.lin@rad-ic.com




-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
