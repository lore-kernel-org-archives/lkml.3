Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaHSVSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:18:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44678 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHSVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:18:22 -0400
Date: Tue, 19 Aug 2014 14:18:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sparc: i8042-sparcio.h: fix unused kbd_res warning
Message-ID: <20140819211816.GA12231@core.coreip.homeip.net>
References: <1408482577-17837-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408482577-17837-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:09:37PM +0200, Vincent Stehlé wrote:
> kbd_res is used only when CONFIG_PCI is defined; condition its declaration as
> well. This fixes the following compilation warning:
> 
>   drivers/input/serio/i8042-sparcio.h:20:25: warning: ‘kbd_res’ defined but not used [-Wunused-variable]
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>

Applied, thank you.

-- 
Dmitry
