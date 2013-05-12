Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3ELOkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:40:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab3ELOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:40:15 -0400
Date: Sun, 12 May 2013 15:40:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Remove unnecessary include of linux/delay.h
	from regulator drivers
Message-ID: <20130512144012.GB30942@opensource.wolfsonmicro.com>
References: <1366267975.28606.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366267975.28606.1.camel@phoenix>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 02:52:55PM +0800, Axel Lin wrote:
> All the drivers that need delay for the regulator voltage output voltage to
> stabilize after being enabled or after being set to a new value has been
> converted to implement enable_time and set_voltage_time_sel callbacks.
> Then regulator core will take care of the necessary delay.

Applied, thanks.
