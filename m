Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3AYPgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:36:20 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35251 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3AYPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:36:18 -0500
Date: Fri, 25 Jan 2013 16:36:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org,
        olh@suse.de, Philippe De Muyter <phdm@macqel.be>
Subject: Re: [PATCH] block/partition/msdos: detect AIX formatted disks even
 without 55aa
Message-ID: <20130125153616.GA27741@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359126343-3525-1-git-send-email-phdm@macqel.be>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMHO that patch would better have a small but important one-liner comment
(one cannot rely on people always making use of SCM history functionality,
thereby this would be at risk of getting reversed accidentally eventually).

E.g.

/* Note order! (some AIX disks, e.g. unbootable kind, have no MSDOS 55aa) */

	if (aix_magic_present(state, data)) {
.
.
.


Apart from that: nice compat catch!

HTH,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
