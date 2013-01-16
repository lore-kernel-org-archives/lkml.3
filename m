Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3APL3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:29:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194Ab3APL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:29:15 -0500
Date: Wed, 16 Jan 2013 20:29:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Liam Girdwood <lrg@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsi: Remove __devinitconst
Message-ID: <20130116112907.GD25480@opensource.wolfsonmicro.com>
References: <1358334585-25046-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358334585-25046-1-git-send-email-thierry.reding@avionic-design.de>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 12:09:45PM +0100, Thierry Reding wrote:
> __devinitconst and friends have recently been removed and must not be
> used anymore.

Applied, thanks.
