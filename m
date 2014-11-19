Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbaKSSJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:09:03 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:61809 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaKSSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:09:00 -0500
MIME-Version: 1.0
In-Reply-To: <1416411048-23526-1-git-send-email-jeffrey.lin@rad-ic.com>
References: <1416411048-23526-1-git-send-email-jeffrey.lin@rad-ic.com>
Date: Wed, 19 Nov 2014 10:08:59 -0800
X-Google-Sender-Auth: 5pJYbUwl8uNItXuxArXx2WSjVpM
Message-ID: <CANLzEkspVpARReWsO8K7cizQ-Ekh0=ntJt0D3JS=GXYDox85Ug@mail.gmail.com>
Subject: Re: [PATCH] driver: input: touchscreen: add Raydium i2c touchscreen driver
From: Benson Leung <bleung@chromium.org>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, dh.herrmann@gmail.com,
        charliemooney@chromium.org, floe@butterbrot.org,
        jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com, KP.li@rad-ic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 7:30 AM, jeffrey.lin <yajohn@gmail.com> wrote:
> From: "jeffrey.lin" <jeffrey.lin@gmail.com>
Also, this email address appears to not be active. Please do not list
dead email addresses as the author.

>
> this patch is porting Raydium I2C touch driver. Developer can enable
> raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
>
> BUG: None
> TEST: built and test with peppy
>
> Signed-off-by: jeffrey.lin@rad-ic.com
> Change-Id: I05d54e5ef29249d2a6eae97222c90bed11e839f9
> ---




-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
