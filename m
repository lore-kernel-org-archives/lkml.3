Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3G2Hdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:33:35 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:50153 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3G2Hdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:33:33 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'NeilBrown'" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com> <20130722090257.2faa0874@notabene.brown> <009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com> <20130726103549.1e6b0b92@notabene.brown> <001e01ce89e6$73f93b80$5bebb280$@lucidpixels.com> <20130729155655.38572fed@notabene.brown>
In-Reply-To: <20130729155655.38572fed@notabene.brown>
Subject: RE: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x SSD)
Date: Mon, 29 Jul 2013 03:33:31 -0400
Message-ID: <001001ce8c2d$ed2d50b0$c787f210$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH8I1r+BgG/efe2pSqBd5Z4Tixg2AHT8x2TAb2IeWUC3a+m2QLoYwVQAjAEZeKYw9hYsA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Monday, July 29, 2013 1:57 AM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
SSD)

On Fri, 26 Jul 2013 05:56:51 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

[..]

Further testing shows all is ok now:


Sun Nov 25 02:12:03 EST 2012: Parity check(s) running, sleeping 60
seconds...
Sun Nov 25 02:13:03 EST 2012: Parity check(s) running, sleeping 60
seconds...
Sun Nov 25 02:14:03 EST 2012: cat /sys/block/md0/md/mismatch_cnt
Sun Nov 25 02:14:03 EST 2012: 0
Sun Nov 25 02:14:03 EST 2012: cat /sys/block/md1/md/mismatch_cnt
Sun Nov 25 02:14:03 EST 2012: 0
Sun Nov 25 02:14:03 EST 2012: The meta-device /dev/md0 has no mismatched
sectors.
Sun Nov 25 02:14:04 EST 2012: The meta-device /dev/md1 has no mismatched
sectors.
Sun Nov 25 02:14:05 EST 2012: All devices are clean...
Sun Nov 25 02:14:05 EST 2012: cat /sys/block/md0/md/mismatch_cnt
Sun Nov 25 02:14:05 EST 2012: 0
Sun Nov 25 02:14:05 EST 2012: cat /sys/block/md1/md/mismatch_cnt
Sun Nov 25 02:14:05 EST 2012: 0

Thanks for your help.

Justin.

