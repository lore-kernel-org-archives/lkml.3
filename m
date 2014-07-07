Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaGGUFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:05:04 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35779 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGGUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:05:02 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 16:05:01 -0400
Message-ID: <CAPDOMVgwJRj40p9FtnezoEmHLDYTJYQ8tDhZ_XyP7VOntFJF-Q@mail.gmail.com>
Subject: Compiler Tests
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am posting in this message which tests still are failing to l
compile from this link,
http://kisskb.ellerman.id.au/kisskb/branch/9/. Please note I didn't test
rand configs. I have posting to the default kernel list due to not knowning
what lists to post to. I can recompile any of these and sent the errors if
needed.
Cheers Nick
Arm - All succeed
Blackfin - BF561-ACVILON_defconfig Fails, BlackStamp_defconfig fails ,
TCM-BF518_defconfig succeeds if building with Uboot support
Cris - no compiler
Power pc - allyesconfig fails
s390x- allnoconfig fails
sh4- rsk7203_defconfig fails , se7206_defconfig fails , shx3_defconfig
 fails , allmodconfig fails , allyesconfig fails
sparc64 - all succeed
um-i386: No compiler
xentsa - fails in defconfig
