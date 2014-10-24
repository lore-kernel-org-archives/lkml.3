Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaJXMHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:07:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbaJXMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:07:12 -0400
Date: Fri, 24 Oct 2014 14:07:06 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: p.zabel@pengutronix.de, dinh.linux@gmail.com, atull@opensource.altera.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] reset: add reset_control_status helper function
Message-ID: <20141024120706.GA27296@pengutronix.de>
References: <1412954474-25775-1-git-send-email-dinguyen@opensource.altera.com>
 <54491859.5010007@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54491859.5010007@opensource.altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:58:41 up 8 days, 23:12, 70 users,  load average: 0,06, 0,05, 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Thu, Oct 23, 2014 at 10:01:45AM -0500, Dinh Nguyen wrote:
> Hi Philipp,
> 
> On 10/10/2014 10:21 AM, dinguyen@opensource.altera.com wrote:
> > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> > 
> > There are cases where a system will want to read a reset status bit before
> > doing any other toggling. Add a reset_control_status helper function to the
> > reset controller API.
> > 
> > Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> > ---
[...]
> Do you have any further comments on this version of that patch? If not,
> can I get an Ack-by?

I have applied it here:
git://git.pengutronix.de/git/pza/linux.git reset-for-3.19

Sorry about the delayed feedback. I was waiting for the Meson reset patches
before pushing the branch, but that might still take a while.

regards
Philipp
