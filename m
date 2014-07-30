Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaG3MWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:22:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42681 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaG3MUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:20:13 -0400
Date: Wed, 30 Jul 2014 14:20:12 +0200
From: Pavel Machek <pavel@denx.de>
To: Charles Manning <cdhmanning@gmail.com>
Cc: linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, cslee@altera.com
Subject: Re: [PATCH 2/3] clk: Prevent a hanging pointer being abused
Message-ID: <20140730122012.GB13965@amd.pavel.ucw.cz>
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
 <1405995634-3297-3-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405995634-3297-3-git-send-email-cdhmanning@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 14:20:33, Charles Manning wrote:
> Clock init structs are normally created on the stack.
> 
> If the pointer is left intact after clk_register then there is
> opportunity for clk drivers to dereference the pointer.
> 
> This was causing a problem in socfpga/clk.c for instance.
> 
> Better to NULL out the pointer so it can't be abused.
> 
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>

Acked-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
