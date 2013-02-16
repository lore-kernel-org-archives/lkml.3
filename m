Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3BPX0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:26:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44669 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3BPX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:26:03 -0500
Date: Sat, 16 Feb 2013 23:25:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
Message-ID: <20130216232550.GQ17833@n2100.arm.linux.org.uk>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360849767-1463135-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
> Recent assembler versions complain about extraneous
> whitespace inside [] brackets. This fixes all of
> these instances for the samsung platforms. We should
> backport this to all kernels that might need to
> be built with new binutils.

I hope that's also been reported as a bug to the binutils people.
