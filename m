Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3F0Pjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:39:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:32492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab3F0Pjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:39:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,953,1363158000"; 
   d="scan'208";a="361502001"
From: "Love, Robert W" <robert.w.love@intel.com>
To: James Bottomley <james.bottomley@hansenpartnership.com>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: fcoe pull request for 3.9-rc
Thread-Topic: fcoe pull request for 3.9-rc
Thread-Index: AQHOceZTUhudfXOeMUiQto/NC5I3wZlJjJUAgACd/QA=
Date: Thu, 27 Jun 2013 15:39:30 +0000
Message-ID: <51CC5CB2.80108@intel.com>
References: <51CA03C1.1040901@intel.com> <1372313642.557.19.camel@dabdike>
In-Reply-To: <1372313642.557.19.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5483A15929D83D4CAEF139215D0C22CE@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5RFdldO015254

On Wed 26 Jun 2013 11:14:02 PM PDT, James Bottomley wrote:
> On Tue, 2013-06-25 at 20:55 +0000, Love, Robert W wrote:
>> The following changes since commit 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82:
>>
>>     Merge branch 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-06-25
>> 09:08:07 -1000)
>>
>> are available in the git repository at:
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git
>> tags/critical_fix_for_3.9
>
> This is simple and I can review from the attached patch, so I'll take it
> this time. But, please, next time follow proper process.  That means the
> individual patches should go over the SCSI mailing list for review
> *before* they're sent in a pull request.
>

The reason I sent this pull request directly to Linus was that the 
patches I mailed at (2013-05-21) RC2 had not yet seen any attention 
since they were posted to linux-scsi. It is now RC7 and with 5 weeks of 
inactivity on my initial 3.10 patch series I had no faith that this 
critical fix would make it through the SCSI tree before the 3.10 kernel 
was released. FYI, Linus has taken this change already.

I would have preferred to send the patch to linux-scsi for review 
first, but it had been thoroughly reviewed on the FCoE list, it's a 
fairly trivial change and I was a hurry to get it into Linus' inbox 
given his statement about "finding new ways to insult your pets." The 
patch is also part of the pull request, so it was review-able by anyone 
on linux-scsi or linux-kernel.

Thanks, //Rob

PS: I totally botched the title of this pull request, obviously it 
should say "fcoe pull request for 3.10-rc".

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
