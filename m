Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3JRBlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:41:14 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5461 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313Ab3JRBlN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:41:13 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>,
        "Gu, Youcai 1 (EXT)" <Youcai1.Gu@sonymobile.com>,
        "Alevoor, Raghavendra 2" <Raghavendra.Alevoor@sonymobile.com>
Date: Fri, 18 Oct 2013 09:41:09 +0800
Subject: RE: BUG report about ipt_do_table( )
Thread-Topic: BUG report about ipt_do_table( )
Thread-Index: Ac7LJXD1SQkKs49CQX6jBKijFcj5DQAfaUzg
Message-ID: <35FD53F367049845BC99AC72306C23D101592A7054D7@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
 <20131010110309.GA6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B5@CNBJMBX05.corpusers.net>
 <20131010141841.GF6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B6@CNBJMBX05.corpusers.net>
 <20131011110247.GF14732@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971BB@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D101592A7054D3@CNBJMBX05.corpusers.net>
 <20131017104123.GH18765@mudshark.cambridge.arm.com>
In-Reply-To: <20131017104123.GH18765@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi   Will

yes, of course .

by the way, could you send me your delivered commit link after you submit ?

Thanks

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Thursday, October 17, 2013 6:41 PM
To: Wang, Yalin
Cc: 'linux-arm-msm-owner@vger.kernel.org'; 'linux-kernel@vger.kernel.org'; Peng, Arthur; Zhang, Bojie; Gu, Youcai 1 (EXT); Alevoor, Raghavendra 2
Subject: Re: BUG report about ipt_do_table( )

On Thu, Oct 17, 2013 at 02:51:34AM +0100, Wang, Yalin wrote:
> Hi  Will,

Hello,

> I am happy to notify that our stability test has passed, And this 
> Crash don't happen again, So seems this patch work now .

Great!

> We has merged it into our release SW .
> Could I know if this patch will be delivered into kernel Mainline by 
> you ?

Sure, can I add your tested-by please?

Will
