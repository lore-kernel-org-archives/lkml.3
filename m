Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3GAHKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:10:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3GAHKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:10:33 -0400
Date: Mon, 1 Jul 2013 09:10:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: apple: Add support for the 2013 Macbook Air
In-Reply-To: <1372619086-3532-2-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1307010909490.29977@pobox.suse.cz>
References: <1372619086-3532-1-git-send-email-rydberg@euromail.se> <1372619086-3532-2-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jun 2013, rydberg@euromail.se wrote:

> This patch adds keyboard support for MacbookAir6,2 as WELLSPRING8
> (0x0291, 0x0292, 0x0293). The touchpad is handled in a separate
> bcm5974 patch, as usual.
> 
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: Brad Ford <plymouthffl@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Dmitry, please feel free to take both patches through your tree, this one 
being

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Thanks.

-- 
Jiri Kosina
SUSE Labs
