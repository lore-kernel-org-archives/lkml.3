Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaLIUfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:35:04 -0500
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:38279 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaLIUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:35:02 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 15:35:02 EST
From: "Young, David" <dayoung@akamai.com>
To: Shuah Khan <shuahkhan@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Dec 2014 15:25:42 -0500
Subject: RE: selftests: question about git repos containing selftest.
Thread-Topic: selftests: question about git repos containing selftest.
Thread-Index: AdAT7ahW6T+t1iLKQVe4YGcF8W2QfAAAHVvw
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
 <CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
In-Reply-To: <CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB9KZENT001553

Thanks, I was definitely looking at the master branch of linux-kselftest.

There are still more changes in linux-next repo, should those be considered as "in progress"?

-dave

-----Original Message-----
From: Shuah Khan [mailto:shuahkhan@gmail.com] 
Sent: Tuesday, December 09, 2014 3:21 PM
To: Greg KH
Cc: Young, David; linux-api@vger.kernel.org; shuahkh@osg.samsung.com; linux-kernel@vger.kernel.org
Subject: Re: selftests: question about git repos containing selftest.

On Tue, Dec 9, 2014 at 12:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 09, 2014 at 02:22:42PM -0500, Young, David wrote:
>> Greetings,
>>
>> I'm trying out the new kernel selftests and was looking for the "bleeding edge" repository to clone.  According to the wiki https://kselftest.wiki.kernel.org/ this is the appropriate repo:
>> git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.g
>> it
>>
>> However, I am finding newer and more frequent changes are in linux-next.
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>
>> Which should I clone for the most fresh changes?
>
> Are you sure you are looking at the correct branch for that git repo?
> Which one were you using?
>

Please find the patches slated for 3.19--rc1 in fixes branch. These are the ones that get pulled into linux-next for integration testing.

-- Shuah
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
