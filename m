Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBCOf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:35:29 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46932 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBCOf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:35:28 -0500
Date: Mon, 3 Feb 2014 15:35:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] regulator: core: Correct default return value for full
  constraints
Message-ID: <20140203153512.3b1d14e4@endymion.delvare>
In-Reply-To: <20140203110249.GA6392@sirena.org.uk>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
	<20140203104141.40cc04e5@endymion.delvare>
	<20140203110249.GA6392@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, 3 Feb 2014 11:02:49 +0000, Mark Brown wrote:
> On Mon, Feb 03, 2014 at 10:41:41AM +0100, Jean Delvare wrote:
> 
> > Can you please review / apply this patch? It fixes a real bug. I also
> > think it should go to the 3.13-stable tree.
> 
> Uh, it is applied?  I'm the one who maintains the regulator tree
> generally...

Ah, I see it in your tree. But it's not in 3.14-rc1. As this fixes a
regression, it would be great to have it upstream ASAP, so that it can
propagate to 3.13-stable.

Thanks,
-- 
Jean Delvare
