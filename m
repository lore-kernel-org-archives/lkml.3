Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3AUP67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:58:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51182 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3AUP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:58:58 -0500
Date: Mon, 21 Jan 2013 15:58:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/33] ARM: Convert to devm_ioremap_resource()
Message-ID: <20130121155846.GN23505@n2100.arm.linux.org.uk>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <1358762966-20791-3-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358762966-20791-3-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:08:55AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.

Does this include the resource part of the handling too?
