Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaIVRxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:53:13 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38403 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaIVRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:53:12 -0400
X-Originating-IP: 75.92.167.159
Date: Mon, 22 Sep 2014 10:53:04 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Please add the tiny tree to linux-next
Message-ID: <20140922175301.GA27348@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you please add the tiny tree, branch tiny/next of
https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git , to
linux-next?

I'll be using this tree to upstream various patches for Linux kernel
tinification.  I plan to use topic branches under tiny/* for separate
topics, typically based on the previous -rc1, merging them into
tiny/next; when the merge window opens, I'll submit a pull request for
tiny/next and start merging new tiny/* topic branches into a
tiny/next-next branch or similar that will become the new tiny/next
after tiny/next gets merged.

- Josh Triplett
