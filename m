Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750792Ab3A1S16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:27:58 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62013 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3A1S1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:27:51 -0500
Date: Mon, 28 Jan 2013 19:27:36 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>, Matt Porter <mporter@ti.com>,
        Chase Maupin <chase.maupin@ti.com>, Jason Kridner <jdk@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
Message-ID: <20130128182736.GD2445@netboy.at.omicron.at>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:11:08PM +0200, Pantelis Antoniou wrote:
> Fix interrupt storm on bone A4 cause by non-by-the-book interrupt handling.
> While at it, added a non-NAPI mode (which is easier to debug), plus
> some general fixes.

This patch does not apply to net-next.

When you do post to netdev, please also put "net" or "net-next" into
the subject line.

Thanks,
Richard
