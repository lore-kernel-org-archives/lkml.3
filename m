Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3AZKFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:05:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55713 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3AZKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:05:49 -0500
Date: Sat, 26 Jan 2013 10:05:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/19] ARM: common warning fixes
Message-ID: <20130126100542.GC23505@n2100.arm.linux.org.uk>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:43:59PM +0000, Arnd Bergmann wrote:
> I will get to those once this series is sorted out.
> Since there are no interdepencies between the patches,
> my preference is to have them applied by the individual
> subsystem maintainers. Anything that has not at
> least made it into linux-next by the next merge window
> and has not received a 'NAK' or been obsoleted by
> another patch, I plan to submit as part of an arm-soc
> branch for 3.9.

And, last night we have new warnings.  My allnoconfigs no longer build
cleanly because of new vexpress section mismatches in the mfd code.

It seems to me that you're on a loosing battle unless you test the tree
and drop code _before_ propaging it out if it adds new warnings... force
the pain of these warnings down on to others so that they learn to create
better code in the first place.
