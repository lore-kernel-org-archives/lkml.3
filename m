Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3BDS1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:27:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:46051 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3BDS1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:27:03 -0500
Date: Mon, 4 Feb 2013 10:27:04 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the mfd tree
Message-ID: <20130204182704.GD3219@kroah.com>
References: <20130204161241.9ba53f0389122d30a2b32ed4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204161241.9ba53f0389122d30a2b32ed4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 04:12:41PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/mfd/wm5102-tables.c between commit d078377faf5f ("mfd: wm5102:
> Refresh register defaults") from the mfd tree and commit 689557d3c704
> ("mfd: wm5102: Add microphone clamp control registers") from the
> char-misc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for this, it looks fine to me.

greg k-h
