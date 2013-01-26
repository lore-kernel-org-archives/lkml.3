Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3AZKH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:07:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55719 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3AZKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:07:52 -0500
Date: Sat, 26 Jan 2013 10:07:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
	regmap_read_debugfs
Message-ID: <20130126100744.GD23505@n2100.arm.linux.org.uk>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-12-git-send-email-arnd@arndb.de> <20130126044219.GA10580@opensource.wolfsonmicro.com> <201301260917.28028.arnd@arndb.de> <20130126094855.GI30594@opensource.wolfsonmicro.com> <20130126095916.GB23505@n2100.arm.linux.org.uk> <20130126100326.GK30594@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126100326.GK30594@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 06:03:28PM +0800, Mark Brown wrote:
> On Sat, Jan 26, 2013 at 09:59:16AM +0000, Russell King - ARM Linux wrote:
> 
> > Why not code the function in a way that avoids the problem altogether?
> 
> That'd do the trick too; feel free to submit a patch...

Sorry, got other things which need doing, so if you want that expect it
sometime next month if I even remember.
