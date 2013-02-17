Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3BQPjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:39:09 -0500
Received: from smtp1.uu.se ([130.238.7.54]:55924 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3BQPjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:39:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20768.63816.104018.377650@pilspetsen.it.uu.se>
Date: Sun, 17 Feb 2013 16:37:44 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org, arm@kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
In-Reply-To: <20130216232550.GQ17833@n2100.arm.linux.org.uk>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
	<1360849767-1463135-3-git-send-email-arnd@arndb.de>
	<20130216232550.GQ17833@n2100.arm.linux.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux writes:
 > On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
 > > Recent assembler versions complain about extraneous
 > > whitespace inside [] brackets. This fixes all of
 > > these instances for the samsung platforms. We should
 > > backport this to all kernels that might need to
 > > be built with new binutils.
 > 
 > I hope that's also been reported as a bug to the binutils people.

See PR gas/14887, a post binutils-2.23.1 regression which seems
to be fixed on trunk but not on 2.23 branch.
