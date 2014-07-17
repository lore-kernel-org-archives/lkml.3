Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbaGQL3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:29:22 -0400
Received: from gw1.transmode.se ([195.58.98.146]:57779 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbaGQL3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:29:16 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2014 07:29:16 EDT
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: ls -l  /proc/1/exe -> Permission denied
X-KeepSent: 6F10655B:C9BFC08D-C1257D18:003D22DF;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
Date: Thu, 17 Jul 2014 13:18:38 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 17/07/2014 13:18:39,
	Serialize complete at 17/07/2014 13:18:39
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to real /proc/<pid>/exe I noticed I could not read links not 
belonging to my user such as:
jocke >  ls -l /proc/1/exe
             ls: cannot read symbolic link /proc/1/exe: Permission denied

Is this expected?

uname -a
Linux gentoo-jocke 3.12.21
