Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3KYWBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:01:18 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57669 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3KYWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:01:13 -0500
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
Date: Mon, 25 Nov 2013 17:01:12 -0500
Message-ID: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
Subject: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: open list <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Using 3.12.0 and ext4fs with 2 x SSDs in a RAID-1 configuration on a
3ware HW RAID card, no md/dm, I noticed the following recently:
[178339.353565] sda2: WRITE SAME failed. Manually zeroing.

It seems to be similar to this issue here:
http://permalink.gmane.org/gmane.linux.kernel/1494512

Relevant logs:
[178339.353519] 3w-sas: scsi0: ERROR: (0x03:0x0101): Invalid command
opcode:opcode=0x41.
[178339.353565] sda2: WRITE SAME failed. Manually zeroing.

Is this something I should be worried about?
I am running a database on the host, could that be the cause of it?
(in the related post, he was also running a DB).

Justin.
