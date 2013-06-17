Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FQX1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:27:01 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46740 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3FQX07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:26:59 -0400
Date: Tue, 18 Jun 2013 01:28:22 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Shyti <andi@etezian.org>, arnd@arndb.de, linux-kernel@vger.kernel.org,
        pc@asdf.org, oatilla@gmail.com
Subject: Re: [PATCH 03/19] bh1770glc: lux0_glass_factor & lux0_comp_factor on
 sysfs
Message-ID: <20130617232822.GB4454@jack.whiskey>
References: <cover.1371145891.git.andi@etezian.org>
 <0336a23507f74f1dcf7c2f7d08ddf77c7d83df26.1371145891.git.andi@etezian.org>
 <20130617225212.GA21613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617225212.GA21613@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Introduced lux0_glass_factor and lux0_comp_factor on sysfs
> > 
> > lux0_glass_factor and lux0_sensor_comp_factor are provided as
> > read-only files on the sysfs structure of the bh1770glc optical sensor.
> 
> You can't add/remove/modify sysfs files without the proper
> Documentation/ABI changes as well.  Please redo this patch with those
> updates.

Right! missed that, I'll resend it

Andi
