Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaIXUjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:39:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48048 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbaIXUjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:39:24 -0400
Message-ID: <54232BF7.5090909@fb.com>
Date: Wed, 24 Sep 2014 16:39:19 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] trace-cmd fixes
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_08:2014-09-24,2014-09-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409240206
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a few outstanding trace-cmd patches that I've sent over the last 
couple of months, the bulk of which were while you were on vacation.  So 
here's a pull-able branch with the current backlog.  The 
"read_next_event" patch is authored today because I nuked the original 
git tree I had with it, but I sent it in July I think.  If these are 
acceptable you can just pull from

https://github.com/josefbacik/trace-cmd.git for-steve

Here is the shortlog

Josef Bacik (4):
       trace-cmd: make sure we have a pending pid in trace-hist
       trace-cmd: add trace-record.o to the python shared lib
       trace-cmd: add read_next_event to python lib
       trace-cmd: add helper to read kernel_stack functions

I've been carrying all but the kernel_stack thing internally for months 
and have scripts using them in production so they are well tested.  Thanks,

Josef
