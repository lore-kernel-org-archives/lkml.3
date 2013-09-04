Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769Ab3IDJ4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:56:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57782 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934205Ab3IDJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:56:13 -0400
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 05:56:13 EDT
Message-ID: <5226FAE1.5070201@fb.com>
Date: Wed, 4 Sep 2013 14:48:25 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, Kumar Sundararajan <kumar@fb.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: clock_gettime_ns
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-04_05:2013-09-04,2013-09-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of years ago Andy posted this patch series:

http://thread.gmane.org/gmane.linux.kernel/1233209/

These patches have been in use at facebook for a couple of years and 
along with a vDSO implementation of thread_cpu_time(), they have proven 
useful for our profilers.

I didn't see any arguments against this patch series. Did I miss some 
discussion on the topic?

  -Arun
