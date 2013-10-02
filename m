Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3JBMNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:13:37 -0400
Received: from etezian.org ([198.101.225.253]:39835 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab3JBMNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:13:36 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 08:13:36 EDT
Date: Wed, 2 Oct 2013 14:06:30 +0200
From: Andi Shyti <andi@etezian.org>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: apw@canonical.com, joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [[RFC]] scripts/robopatch.pl: the mechanical bride of
 checkpatch.pl
Message-ID: <20131002120630.GA4179@jack.whiskey>
References: <1375784829-5974-1-git-send-email-phil.carmody@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375784829-5974-1-git-send-email-phil.carmody@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +# $ scripts/checkpatch.pl WHATEVER > /tmpcheckpatch.log
                                           ^^

I guess you have a typo here.

I actually used this, it doesn't know what msleep is and it
fails, so that to go ahead I had to remove the msleep lines from
/tmp/checpatch.log.

Andi
