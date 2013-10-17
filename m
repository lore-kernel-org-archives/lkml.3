Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3JQKla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:41:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44542 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab3JQKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:41:29 -0400
Date: Thu, 17 Oct 2013 11:41:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>,
        "Gu, Youcai 1 (EXT)" <Youcai1.Gu@sonymobile.com>,
        "Alevoor, Raghavendra 2" <Raghavendra.Alevoor@sonymobile.com>
Subject: Re: BUG report about ipt_do_table( )
Message-ID: <20131017104123.GH18765@mudshark.cambridge.arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D101592A7054D3@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 02:51:34AM +0100, Wang, Yalin wrote:
> Hi  Will, 

Hello,

> I am happy to notify that our stability test has passed,
> And this Crash don't happen again,
> So seems this patch work now .

Great!

> We has merged it into our release SW .
> Could I know if this patch will be delivered into kernel
> Mainline by you ? 

Sure, can I add your tested-by please?

Will
