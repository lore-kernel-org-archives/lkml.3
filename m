Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaLIVPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:15:09 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:51941 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbaLIVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:15:04 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 16:15:03 EST
From: "Young, David" <dayoung@akamai.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Dec 2014 16:08:39 -0500
Subject: RE: selftests: question about git repos containing selftest.
Thread-Topic: selftests: question about git repos containing selftest.
Thread-Index: AdAT731Flg35Hxw+R/+cjGUO8/aUkgAA+d/Q
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C56@USMBX1.msg.corp.akamai.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
	<CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
 <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
In-Reply-To: <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB9LFIPD001939


> Do you have specific patches in linux-next that you have questions about?

Mostly I am interested in executing kselftests via something like autotest or Hudson/jenkins as a quick smoketest.  I understand it's still very much an in-progress feature, but would like the closest thing to a stable set of tests to regularly clone and use.  I suppose I could just wait for whatever makes it into mainline, but I'm interested in seeing the planned test coverage and test output so that I can write appropriate "glue" for use with a continuous-integration test system.

-dave


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
