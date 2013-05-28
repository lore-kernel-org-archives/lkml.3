Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3E1KU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:20:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab3E1KU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:20:26 -0400
Date: Tue, 28 May 2013 12:20:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christian Ohm <chr.ohm@gmx.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: Add driver for Holtek gaming mouse 04d9:a067
In-Reply-To: <39428ed7f69bd06e3d93f730ba8f7b7b0a3f6c26.1369083628.git.chr.ohm@gmx.net>
Message-ID: <alpine.LNX.2.00.1305281219490.3914@pobox.suse.cz>
References: <cover.1369083628.git.chr.ohm@gmx.net> <39428ed7f69bd06e3d93f730ba8f7b7b0a3f6c26.1369083628.git.chr.ohm@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013, Christian Ohm wrote:

> This mouse is sold as Sharkoon Drakonia and Perixx MX-2000 and reports a
> too high usage maximum and logical maximum. This driver fixes the report
> descriptor so those values don't exceed HID_MAX_USAGES.
> 
> Signed-off-by: Christian Ohm <chr.ohm@gmx.net>
> ---
>  drivers/hid/Kconfig            |    1 +
>  drivers/hid/Makefile           |    1 +
>  drivers/hid/hid-holtek-mouse.c |   72 ++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-ids.h          |    1 +
>  4 files changed, 75 insertions(+)
>  create mode 100644 drivers/hid/hid-holtek-mouse.c

You also need an entry in hid_have_special_driver[] for the devices in 
order for the device <-> driver binding work properly.

I have applied your patches and fixed that omission.

-- 
Jiri Kosina
SUSE Labs
