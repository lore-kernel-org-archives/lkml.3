Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaLIVaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:30:06 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:33962 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaLIVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:30:04 -0500
From: "Young, David" <dayoung@akamai.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Dec 2014 16:29:57 -0500
Subject: RE: selftests: question about git repos containing selftest.
Thread-Topic: selftests: question about git repos containing selftest.
Thread-Index: AdAT9u1CTEFxyYfAQ6OfHKprZJRrkAAAD+Jw
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C79@USMBX1.msg.corp.akamai.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
	<CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
	<CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C56@USMBX1.msg.corp.akamai.com>
 <CAKocOOMNS3tZq3nFg7rTFnPRZwV0U-y4=34Yph+qTYN0kqTuQA@mail.gmail.com>
In-Reply-To: <CAKocOOMNS3tZq3nFg7rTFnPRZwV0U-y4=34Yph+qTYN0kqTuQA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB9LUGlb002123

Thanks for clearing this up, very helpful!

-dave

-----Original Message-----
From: Shuah Khan [mailto:shuahkhan@gmail.com] 
Sent: Tuesday, December 09, 2014 4:27 PM
To: Young, David
Cc: Greg KH; linux-api@vger.kernel.org; shuahkh@osg.samsung.com; linux-kernel@vger.kernel.org
Subject: Re: selftests: question about git repos containing selftest.

On Tue, Dec 9, 2014 at 2:08 PM, Young, David <dayoung@akamai.com> wrote:
>
>> Do you have specific patches in linux-next that you have questions about?
>
> Mostly I am interested in executing kselftests via something like autotest or Hudson/jenkins as a quick smoketest.  I understand it's still very much an in-progress feature, but would like the closest thing to a stable set of tests to regularly clone and use.  I suppose I could just wait for whatever makes it into mainline, but I'm interested in seeing the planned test coverage and test output so that I can write appropriate "glue" for use with a continuous-integration test system.
>

David,

Please follow fixes branch for patches that are going to be in the next mainline release. I am planning to create devel or experimental branch to make my next revision install target patches available for early testing for people that want to play with work in progress. Hope this is helpful.

thanks,
-- Shuah
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
