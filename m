Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3BLSBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:01:14 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33632 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab3BLSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:01:12 -0500
Date: Tue, 12 Feb 2013 19:00:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Tejun Heo <tj@kernel.org>
Cc: Wolfram Sang <wolfram@the-dreams.de>, akpm@linux-foundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH -mm] i2c: style cleanups after idr_alloc() conversion
Message-ID: <20130212190058.3d987d85@endymion.delvare>
In-Reply-To: <20130212173648.GE7348@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
	<1360179649-22465-38-git-send-email-tj@kernel.org>
	<20130207152831.GA14797@sirena.org.uk>
	<20130207163247.GL2875@htj.dyndns.org>
	<20130207163958.GY4720@opensource.wolfsonmicro.com>
	<20130207165547.GO2875@htj.dyndns.org>
	<20130210114729.GB5472@nekote.pengutronix.de>
	<20130212173414.GD7348@htj.dyndns.org>
	<20130212173648.GE7348@htj.dyndns.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 09:36:48 -0800, Tejun Heo wrote:
> On Tue, Feb 12, 2013 at 09:34:14AM -0800, Tejun Heo wrote:
> > Style cleanups suggested by Wolfram.
> > 
> > * s/res/id/ in i2c_add_numbered_adapter() so that it matches
> >   i2c_add_adapter().
> > 
> > * Add a blank line before return in i2c_add_numbered_adapter().
> > 
> > This patch is purely cosmetic.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Wolfram Sang <w.sang@pengutronix.de>
> 
> JFYI, got a permanent delivery failure for w.sang@pengutronix.de.
> Does anyone in i2c circle know other contact points?  If so, please
> ping him about it.

See the updated Cc list :)

-- 
Jean Delvare
