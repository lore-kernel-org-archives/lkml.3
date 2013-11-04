Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3KDKZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:25:33 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:44565 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3KDKZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:25:31 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: 3.12: raid-1 mismatch_cnt question
Date: Mon, 4 Nov 2013 05:25:28 -0500
Message-ID: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac7ZSAghnp84jgcPQpKT/JB6XBqEMw==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I run two SSDs in a RAID-1 configuration and I have a swap partition on a
third SSD.  Over time, the mismatch_cnt between the two devices grows higher
and higher.

Once a week, I run a check and repair against the md devices to help bring
the mismatch_cnt down.  When I run the check and repair, the system is live
so there are various logs/processes writing to disk.  The system also has
ECC memory and there are no errors reported.

The following graph is the mismatch_cnt from June 2013 to current; each drop
represents a check+repair.  In September, I dropped the kernel/vm caches
before running check/repair and that seemed to help a bit.
http://home.comcast.net/~jpiszcz/20131104/md_raid_mismatch_cnt.png

My question is: is this normal or should the mismatch_cnt always be 0 unless
there is a HW or md/driver issue?

Justin.

