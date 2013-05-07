Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3EGBot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:44:49 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35507 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3EGBos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:44:48 -0400
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 11:44:42 +1000
MIME-Version: 1.0
Subject: Kernel Firmware Support
Message-ID: <51885C8A.28146.10AA3F@msetzerii.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking for method to best support users firmware needs within 
the kernel. 

Have a disk-image project that users kernel.org kernels, and have 
had users that require firmware that is not included in the 
kernel.org source. I've been able to find it in linux-firmware.git and 
then manually adding it to the kernel.org firmware directory and 
then modifying the Makefile.

Had seen something that was suppose to be working on getting 
firmware out of the kernel, but that process seems to have been 
dormant for some time. 


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
SETI        14672667.574611   |   EINSTEIN    11160884.209852
ROSETTA      7189167.439443   |   ABC         15954188.106838

