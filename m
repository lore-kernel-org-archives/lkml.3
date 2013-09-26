Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3IZHbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab3IZHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:31:03 -0400
Date: Thu, 26 Sep 2013 13:00:51 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: Rob Landley <rob@landley.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
In-Reply-To: <1380128199.1974.89@driftwood>
Message-ID: <alpine.LFD.2.03.1309261240380.10813@erqung.pbz>
References: <1380128199.1974.89@driftwood>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Wed, 25 Sep 2013, Rob Landley wrote --+
| Ah, so it's an out of tree bespoke Red Hat tool. No wonder I couldn't find it.

  It is not Red Hat tool.

| You're reimplemented the posix "pax" command?

  Ummn, not sure. Didn't see anything about 'pax'.
 
| Is this what you're currently doing, or the change you're requesting in the 
| kernel?

  Yes, I'm proposing to export $INITRD_COMPRESS variable so that it can be 
used by dracut(8).

| How does your code get called?

  The patch's commit log explains it.


Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
