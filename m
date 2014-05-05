Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaEEAFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:17 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:41020 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751695AbaEEAFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:3868:3873:4250:4321:5007:6261:7903:10004:10026:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12679:12683:12740:13311:13357:14095:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brain16_2dbce8165870a
X-Filterd-Recvd-Size: 1830
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] cdrom: neatening
Date: Sun,  4 May 2014 17:05:01 -0700
Message-Id: <cover.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens.

I was cleaning up a bunch of old stuff on my computer
and noticed these...

On Mon, 2013-07-22 at 16:08 -0600, Jens Axboe wrote:
> On 07/22/2013 04:08 PM, Joe Perches wrote:
> > Anything going to happen via you with these patches?
> I'll queue them up for 3.12.

Awhile ago these might have been queued up somewhere,
but as far as I can tell, never got applied.

Joe Perches (12):
  cdrom: convert cdinfo to cd_dbg
  cdrom: Remove unused CHECKAUDIO macro
  cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
  cdrom: Remove prototype for open_for_data
  cdrom: Remove unnecessary check_for_audio_disc prototype
  cdrom: Remove unnecessary sanitize_format prototype
  cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
  cdrom: Remove cdrom_get_last_written prototype
  cdrom: Remove cdrom_get_next_writeable prototype
  cdrom: Remove cdrom_count_tracks prototype
  cdrom: Remove unnecessary prototype for cdrom_mrw_exit
  cdrom: Remove unnecessary prototype for cdrom_get_disc_info

 drivers/cdrom/cdrom.c | 1357 +++++++++++++++++++++++++------------------------
 1 file changed, 681 insertions(+), 676 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

