Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3BGP2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:28:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60280 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3BGP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:28:45 -0500
Date: Thu, 7 Feb 2013 15:28:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 37/77] i2c: convert to idr_alloc()
Message-ID: <20130207152831.GA14797@sirena.org.uk>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360179649-22465-38-git-send-email-tj@kernel.org>
X-Cookie: We read to say that we have read.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:40:09AM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.

This broke I2C for me in -next today, I saw a spinlock bad magic error
calling pm_runtime_enable().  
