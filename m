Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3KHNhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:37:32 -0500
Received: from smtprelay0202.b.hostedemail.com ([64.98.42.202]:52044 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626Ab3KHNhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:37:31 -0500
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:,RULES_HIT:41:152:355:379:582:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2692:2741:3138:3139:3140:3141:3142:3352:3421:3622:3865:3866:3867:3870:3871:3872:3874:4250:4361:5007:6119:6120:6261:6691:7901:7903:7996:9108:10004:10400:10450:10455:10848:11658:11914:12517:12519:12679:13069:13071:13161:13229:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: men44_7ba66bc786919
X-Filterd-Recvd-Size: 1667
Date: Fri, 8 Nov 2013 13:37:29 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1600311353.38386.1383917849694.JavaMail.mail@webmail14>
Subject: Not being able to reread the partition table - why is Linux so 90x?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.168.227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wonder why in 2013 I still cannot modify _unused_ partitions on the fly,
yeah, the Internet is full of:

# hdparm -z /dev/sda

/dev/sda:
 re-reading partition table
 BLKRRPART failed: Device or resource busy

# fdisk (after adding a new partition using unused space on my hdd)
...
Command (m for help): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
Re-reading the partition table failed.: Device or resource busy

SCSI rescan command doesn't work too.

I do understand that the Linux kernel doesn't have any form of invoke() but
then it prevents me from altering the partitions which are not used - it's
100% counter intuitive. Windows, for instance, allows to modify even a
system partition on the fly since 2006, Linux doesn't allow to add partitions
without rebooting the system.

Could anyone elaborate, please?

Best regards,

Artem
