Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaBUCtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:49:04 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46621 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBUCtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:49:03 -0500
X-AuditID: 85900ec0-d0927b9000001514-2f-5306be9bb5e2
Message-ID: <5306BE9B.1010909@hitachi.com>
Date: Fri, 21 Feb 2014 11:48:59 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: hare@suse.de
Cc: mlombard@redhat.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com, kay@vrfy.org, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, hidehiro.kawai.ez@hitachi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
in-reply-to: 53047DA0.4030100@suse.de
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

We want to handle the error message in userland for HA clusters, so the
error messages should be output in single(atomic) line. However, current
upstream kernel outputs SCSI error messages in multiple lines, so
current implementation is inconvenient. Even if human reads the error
messages, the split messages are difficult to read. Therefore, the
split error messages should be fixed.

In order to solve this problem, recently I submitted the patch fixing
SCSI error message split[1] to LKML. However, when I read the
discussion of you and Maurizio, I noticed that you already have fixed
in your branch.

When will you send your branch to linux-kernel ML or linux-scsi ML?

[1] https://lkml.org/lkml/2014/1/15/926
[2] http://marc.info/?t=139280071900001&r=1&w=2

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

