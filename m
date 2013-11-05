Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3KEUBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:01:33 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34576 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KEUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:01:32 -0500
Date: Tue, 5 Nov 2013 21:01:30 +0100
From: Andreas Mohr <andi@lisas.de>
To: Simon Easter <simon.easter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix SD card detection and use correct transfer
 interval.
Message-ID: <20131105200130.GA32741@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20131005T140209-999@post.gmane.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

to revive a rather neglected topic (still no reply?):

> I don't suppose you have a patch for this version?, not quite sure if reading
> the patch file properly but assuming I get changes in what is the correct
> way to just compile this module and insert into running config?

Try

make M=sound/pci modules

(and perhaps followed by modules_install, too)

or perhaps even simply
make drivers/char/rtc.ko


I'm working on extending some relevant docs, too, but don't hold your breath...
(slowly but surely extending my local git data store)

Andreas Mohr
