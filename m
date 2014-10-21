Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbaJUUyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:54:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaJUUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:54:23 -0400
Date: Tue, 21 Oct 2014 13:54:38 -0700
From: Darren Hart <dvhart@infradead.org>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: mjg59@srcf.ucam.org, jlee@suse.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: platform: change 0x20 to I8042_STR_AUXDATA in
 i8042 filters
Message-ID: <20141021205438.GD20951@vmdeb7>
References: <1413590240-18762-1-git-send-email-giedriuswork@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413590240-18762-1-git-send-email-giedriuswork@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 02:57:20AM +0300, Giedrius Statkevicius wrote:
> From: Giedrius Statkevičius <giedriuswork@gmail.com>
> 
> Instead of using a magic constant 0x20 in some drivers to get data only
> from the KBC port we should use the constant defined in i8042.h with
> the same value. Also, this makes these drivers uniform with what
> constant the only other filter function uses in 
> drivers/input/misc/ideapad_slidebar.c.
> 
> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>

Queued, thanks Giedrius.

-- 
Darren Hart
Intel Open Source Technology Center
