Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaGJVW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:22:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaGJVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:22:57 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>
Subject: [RFC] trace-cmd: add the ability to install libtracecmd
Date: Thu, 10 Jul 2014 17:22:45 -0400
Message-ID: <1405027367-26570-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-10_07:2014-07-10,2014-07-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.39887054664933e-10 kscore.compositescore=0
 circleOfTrustscore=22.4078557653337 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407100242
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to build some custom tracing tools on top of trace-cmd but they
aren't really usefull outside of Facebook so I don't want to shove them into the
actual trace-cmd project.  Instead I'd like to be able to just build libtracecmd
and install that as well as the necessary header files and just link my tools
against that.  I'm shit at userspace stuff like this, so I've just hacked
something together that works for me.  I'm mostly hoping somebody will look at
the Makefile horribleness that I came up with and tell me how to do it right (or
better yet do it for me!)  The second patch just cleans up some stuff to make
the shared library more library esque.  Any feedback would be great.  Thanks,

Josef

