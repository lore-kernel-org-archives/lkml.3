Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161689AbaKNSAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:00:47 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33451 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460AbaKNSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:00:46 -0500
Date: Fri, 14 Nov 2014 10:00:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: rydberg@euromail.se, olof@lixom.net, dianders@chromium.org,
        benzh@chromium.org, davidriley@chromium.org, bleung@chromium.org,
        joe.konno@intel.com, jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com,
        KP.li@rad-ic.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] driver: input :touchscreen : add Raydium I2C touch driver
Message-ID: <20141114180041.GA14513@dtor-ws>
References: <1415949562-14957-1-git-send-email-jeffrey.lin@rad-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415949562-14957-1-git-send-email-jeffrey.lin@rad-ic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeffrey,

On Fri, Nov 14, 2014 at 03:19:22PM +0800, jeffrey.lin wrote:
> From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
> 
> this patch is porting Raydium I2C touch driver.

Thank you for your submission.

>  Developer can enable
>  Raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM31100"
>  in config/base.config

This does not make sense in context of mainline kernel, it is Chromeos
(or Android?) construct.

Also, for mainline submission, please get rid of EARLYSUSPEND bits,
convert the driver to threaded interrupt handler instead of private
workqueue, remove driver specific device interface, #if 0., DEBUG_PRINT,
convert to MT-B protocol.

Thank you.

-- 
Dmitry
