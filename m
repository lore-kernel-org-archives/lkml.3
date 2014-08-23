Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaHWPVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:21:17 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45715 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHWPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:21:16 -0400
X-Originating-IP: 50.43.15.134
Date: Sat, 23 Aug 2014 08:21:04 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: dri-devel@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 0/9] use c99 initializers in structures
Message-ID: <20140823152104.GC2074@thin>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 01:20:22PM +0200, Julia Lawall wrote:
> These patches add labels in the initializations of structure fields (c99
> initializers).  The complete semantic patch thta makes this change is shown
> below.  This rule ignores cases where the initialization is just 0 or NULL,
> where some of the fields already use labels, and where there are nested
> structures.

I responded to patches 6 and 8 with comments; for the rest (1-5, 7, 9):
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
