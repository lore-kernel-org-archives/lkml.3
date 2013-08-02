Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3HBSDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:03:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54589 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab3HBSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:03:42 -0400
From: Dan Williams <djbw@fb.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] dmatest: make module parameters writable
Thread-Topic: [PATCH 1/3] dmatest: make module parameters writable
Thread-Index: AQHOh7p6sYhbiZEqiE253lzrXOCaM5l/WkAAgALnlYCAAHdpAP//jHyA
Date: Fri, 2 Aug 2013 18:03:29 +0000
Message-ID: <CE2141DE.1D2FE%djbw@fb.com>
In-Reply-To: <1375466216.22073.6.camel@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="euc-kr"
Content-ID: <0F98F7118621384B9267FFC0FC2B6657@fb.com>
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-02_06:2013-08-02,2013-08-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r72I3mts032198



On 8/2/13 10:56 AM, "Steven Rostedt" <rostedt@goodmis.org> wrote:

>On Fri, 2013-08-02 at 17:49 +0000, Dan Williams wrote:
>
>> However, unless I missed it, I don©öt see this support[1] upstream yet.
>> 
>> 
>> --
>> Dan
>> 
>> [1]: https://lwn.net/Articles/432186/
>
>IIRC, there was some push back from doing this. I don't really remember
>who? Rusty maybe?
>
>Or maybe not, it seems he had some comments on it in that thread:
>
>http://thread.gmane.org/gmane.linux.kernel/1110481
>
>Perhaps I got busy and dropped it :-/
>
>Anyway, if there's a demand for it, we can always revisit the idea.

Dmatest has infrastructure to collect a list of test result messages and
output them on-demand when reading a debugfs file.  I figure we might as
well trace them but would want to enable the tracepoints when the module
is loaded.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
