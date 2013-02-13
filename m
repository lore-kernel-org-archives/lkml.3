Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab3BMUmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:42:08 -0500
Received: from sauhun.de ([89.238.76.85]:38924 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab3BMUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:42:05 -0500
Date: Wed, 13 Feb 2013 21:42:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tejun Heo <tj@kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, akpm@linux-foundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH -mm] i2c: style cleanups after idr_alloc() conversion
Message-ID: <20130213204201.GA19993@nekote.pengutronix.de>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
 <20130207163958.GY4720@opensource.wolfsonmicro.com>
 <20130207165547.GO2875@htj.dyndns.org>
 <20130210114729.GB5472@nekote.pengutronix.de>
 <20130212173414.GD7348@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212173414.GD7348@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:34:14AM -0800, Tejun Heo wrote:
> Style cleanups suggested by Wolfram.
> 
> * s/res/id/ in i2c_add_numbered_adapter() so that it matches
>   i2c_add_adapter().
> 
> * Add a blank line before return in i2c_add_numbered_adapter().
> 
> This patch is purely cosmetic.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Wolfram Sang <wolfram@the-dreams.de>

Would be nice to fold this patch into the previous one, if possible.
