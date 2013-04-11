Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935871Ab3DKO1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:27:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34167 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765597Ab3DKO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:27:35 -0400
Date: Thu, 11 Apr 2013 15:27:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: regulator: Some patches for twl-regulator are not found in
	regulator tree
Message-ID: <20130411142734.GC24971@opensource.wolfsonmicro.com>
References: <1365646391.3832.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365646391.3832.2.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:13:11AM +0800, Axel Lin wrote:

> I found some patches for twl are not in linux-next, and I cannot find them
> in your tree ( although you replied the patches applied. )
> 
> I think below patches are missing:
> [PATCH] regulator: twl: Remove TWL6030_FIXED_RESOURCE [1]
> [PATCH] regulator: twl: Remove VDD1_VSEL_table and VDD2_VSEL_table [2]
> [PATCH] regulator: twl: Convert fixed voltage to use regulator_list_voltage_linear [3]

Please resend if you think things are missing.
