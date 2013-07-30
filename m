Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3G3QBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:01:44 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57533 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3G3QBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:01:42 -0400
Date: Tue, 30 Jul 2013 18:01:33 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 0/2] OCTEON GPIO support.
Message-ID: <20130730160133.GA5411@linux-mips.org>
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:29:08PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The Cavium, OCTEON is a MIPS based SoC.  Here we add support for its
> on-chip GPIO lines.
> 
> Changes from v1: Cleaned up variable names, messages and added some
> comments as suggested by Linus Walleij.
> 
> The second patch depends on the first, but is in code maintained by
> Ralf.  It may be best to mrege both of these together, perhaps from
> the GPIO tree, with Ralf's Acked-by.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
