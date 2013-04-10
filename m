Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095Ab3DJJsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935049Ab3DJJsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:48:40 -0400
Date: Wed, 10 Apr 2013 06:48:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with the v4l-dvb tree
Message-ID: <20130410064828.6c946ad8@redhat.com>
In-Reply-To: <20130410064253.GA4874@zurbaran>
References: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
	<20130410064253.GA4874@zurbaran>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 10 Apr 2013 08:42:53 +0200
Samuel Ortiz <sameo@linux.intel.com> escreveu:

> Hi Stephen,
> 
> On Wed, Apr 10, 2013 at 01:48:13PM +1000, Stephen Rothwell wrote:
> > Hi Samuel,
> > 
> > Today's linux-next merge of the mfd tree got a conflict in
> > drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
> > files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
> > commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
> > mfd tree.
> I'm surprised the v4l-dvb tree is carrying this patchset because I haven't
> ACKed it. 

Sorry. Not sure why I understood that you gave your ack. Perhaps I miss-read
one of the comments of that thread.

> I was planning to take the MFD bits of it and provide Mauro a branch
> to pull from (Including the mfd/Kconfig change).
> Mauro, could we please go that way instead ? This conflict does not look
> pretty to me.

Sure. Do you have such branch already? As the patches are on my main
tree[1], I'll need to either revert them or to do a merge from your
branch. The latter is likely a little cleaner, but I'm ok with either ways.

Regards,
Mauro

[1] Currently, we're not using topic branches yet. I'm planning to do it
for 3.11. So, once a patch got merged, I can't remove it, as I don't
rebase my tree.

Regards,
Mauro
