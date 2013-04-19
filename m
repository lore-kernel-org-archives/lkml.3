Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282Ab3DSMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:17:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34724 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968240Ab3DSMRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:17:16 -0400
Date: Fri, 19 Apr 2013 13:16:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCHv2 arm: initial TI-Nspire support]
Message-ID: <20130419121652.GK14496@n2100.arm.linux.org.uk>
References: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:51:43PM +1000, Daniel Tang wrote:
> +	.cntl		= (CNTL_BGR | CNTL_LCDTFT | CNTL_LCDVCOMP(1) |
> +				CNTL_LCDBPP16_565),

NAK.  Use the panel capabilities instead.
