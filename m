Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3GBI1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:27:22 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:56863 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753309Ab3GBI1T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:27:19 -0400
X-ASG-Debug-ID: 1372753635-053ea947e82e8f80001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
To: Mike Snitzer <snitzer@gmail.com>
CC: Amit Phansalkar <aphansalkar@stec-inc.com>,
        "thornber@redhat.com" <thornber@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "Jens Axboe" <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "Padmini Balasubramaniyan" <padminib@stec-inc.com>,
        "koverstreet@google.com" <koverstreet@google.com>
Subject: RE: Performance Comparison among EnhanceIO, bcache and dm-cache.
Thread-Topic: Performance Comparison among EnhanceIO, bcache and dm-cache.
X-ASG-Orig-Subj: RE: Performance Comparison among EnhanceIO, bcache and dm-cache.
Thread-Index: AQHOaKoi3ZDPNgozIE2Qnh8POgAh+JlRKGdg
Date: Tue, 2 Jul 2013 08:25:17 +0000
Message-ID: <D399C715A2AD7F4F891A75871FC3117508A112@MYMBX3.stec-inc.ad>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
 <CAMM=eLfKku3CuHUS-0Akv=FdEzk_OWz3j+3oTAWCrFnFLZ0b1g@mail.gmail.com>
In-Reply-To: <CAMM=eLfKku3CuHUS-0Akv=FdEzk_OWz3j+3oTAWCrFnFLZ0b1g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.131]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1372753635
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.135574
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Jun 11, 2013 11:06 AM, "OS Engineering" <osengineering@stec-inc.com> wrote:
>>
>> Hi Jens,
>>
>> In continuation with our previous communication, we have carried out performance comparison among EnhanceIO, bcache and dm-cache.

>How reproducible are these results?  Any chance you could do 5-10 runs to get the avg and stddev?  May (or may not) prove interesting.

Hi mike,

We found that, in case of write through caches, the test results were consistent for all caching solution with EnhanceIO providing better throughput in comparison to bcache and dm-cache. However, under write-back mode, dm-cache showed a large standard deviation. The results for EnhanceIO and bcache were consistent with EnhanceIO providing higher throughput when compared to bcache.

We have performed 5 runs for all our performance tests and observed their mean and standard deviations. 
The test results can be found at: https://gist.github.com/sanoj-stec/5858574
The test scripts can be found at:  https://github.com/stec-inc/EnhanceIO/tree/master/performance_test

Regards,
Sanoj

