Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab3AQHNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 02:13:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33669 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab3AQHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 02:13:35 -0500
Date: Thu, 17 Jan 2013 16:13:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8755: Remove enum bucks
Message-ID: <20130117071327.GG20199@opensource.wolfsonmicro.com>
References: <1357525711.16331.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357525711.16331.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 10:28:31AM +0800, Axel Lin wrote:
> We already have enum lp8755_bucks in lp8755.h, so it looks pointless adding
> enum bucks in lp8755.c.

Applied, thanks.
