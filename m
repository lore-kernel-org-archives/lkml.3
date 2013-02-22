Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3BVJvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:51:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3BVJvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:51:48 -0500
Date: Fri, 22 Feb 2013 10:51:46 +0100
From: Michal Marek <mmarek@suse.cz>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, james.hogan@imgtec.com,
        lliubbo@gmail.com
Subject: Re: [PATCH] scripts/link-vmlinux.sh: source variables from
	KCONFIG_CONFIG
Message-ID: <20130222095138.GA12402@pobox.suse.cz>
References: <20130108180525.GA23773@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108180525.GA23773@pengutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 07:05:26PM +0100, Michael Grzeschik wrote:
> Its possible to superseed the config file with KCONFIG_CONFIG and have
> completely no .config in the tree. The current script is sourcing
> .config in every case, so the kernel will never build succesfully. This
> patch fixes that issue by sourcing KCONFIG_CONFIG instead.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Applied to kbuild.git#kbuild, thanks.

Michal
