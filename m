Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3GYXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:10:55 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:54700 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3GYXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:10:53 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'NeilBrown'" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com> <20130722090257.2faa0874@notabene.brown>
In-Reply-To: <20130722090257.2faa0874@notabene.brown>
Subject: RE: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x SSD)
Date: Thu, 25 Jul 2013 19:10:50 -0400
Message-ID: <009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH8I1r+BgG/efe2pSqBd5Z4Tixg2AHT8x2TmQwxymA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Sunday, July 21, 2013 7:03 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
SSD)

> Hi Justin,
>  this is a known bug.  Fix has been accepted into mainline for 3.11-rc2.
>  Hopefully it will get into 3.10.3 (too late for 3.10.2).

> NeilBrown


Hi Neil,

Did the fix by chance make it into 3.10.3?

The same issue occurs with 3.10.3 for me as well:

Every 1.0s: cat /proc/mdstat                            Thu Jul 25 19:09:46
2013

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (151488/233381376)
finish=32045.3m
in speed=121K/sec

md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]

unused devices: <none>



Justin.

