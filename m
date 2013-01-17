Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3AQHGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 02:06:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48462 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758644Ab3AQHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 02:06:17 -0500
Date: Thu, 17 Jan 2013 16:06:12 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8788-buck: Remove buck[1|2]_vout_addr array
Message-ID: <20130117070610.GE20199@opensource.wolfsonmicro.com>
References: <1358387866.17958.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358387866.17958.4.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 09:57:46AM +0800, Axel Lin wrote:
> The vout address for buck[1|2] can be easily calculated,
> thus remote these arrays.

Applied, thanks.
