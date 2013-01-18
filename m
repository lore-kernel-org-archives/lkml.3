Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3ARGZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:25:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59375 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab3ARGZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:25:17 -0500
Date: Fri, 18 Jan 2013 15:25:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp872x: Remove _rdev_to_offset() function
Message-ID: <20130118062510.GC4960@opensource.wolfsonmicro.com>
References: <1358476199.25899.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358476199.25899.3.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:29:59AM +0800, Axel Lin wrote:
> There is only one caller calling _rdev_to_offset(), and the code
> looks simper if we remove _rdev_to_offset(). Thus remove it.

This doesn't seem to apply to topic/lp872x?
