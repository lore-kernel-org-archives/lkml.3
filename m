Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3DFK0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:26:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43918 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab3DFK0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:26:04 -0400
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 06 Apr 2013 20:25:57 +1000
MIME-Version: 1.0
Subject: Error in linux-3.0.72 build.
Message-ID: <515FF835.28644.1FF1E@msetzerii.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just downloaded new kernels, and find this error in build.

fs/built-in.o: In function `find_group_flex':
/home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:359: undefined 
reference to `__udivdi3'
/home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:374: undefined 
reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1
  
+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        14361044.287140   |   EINSTEIN    10723942.979852
ROSETTA      6832434.144171   |   ABC         15903532.519753

