Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3JJFEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:04:50 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:18732 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab3JJFEt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:04:49 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Oct 2013 13:04:41 +0800
Subject: RE: SDIV / UDIV  Question
Thread-Topic: SDIV / UDIV  Question
Thread-Index: Ac7E3e52Lx0GfS52TyKYJV0V45BhWAAmBX0w
Message-ID: <35FD53F367049845BC99AC72306C23D1014D1A0971B0@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971AC@CNBJMBX05.corpusers.net>
 <20131009105357.GC6564@mudshark.cambridge.arm.com>
In-Reply-To: <20131009105357.GC6564@mudshark.cambridge.arm.com>
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

Hi  Will ,


Oh ,  I see ,
Thanks for your clarification !
So R-class cores will not run linux ?
This means we don't  need  care about this .
Am I right ?

Thank you .

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Wednesday, October 09, 2013 6:54 PM
To: Wang, Yalin
Cc: 'linux-arm-msm-owner@vger.kernel.org'; linux-kernel@vger.kernel.org
Subject: Re: SDIV / UDIV Question

On Wed, Oct 09, 2013 at 08:08:05AM +0100, Wang, Yalin wrote:
> I have a question about sdiv/ udiv  instructions :
> In  armv7 A/R  TRM, it said sdiv/udiv will cause Divide by zero as 
> undefined exception or just return zero (decided by implementation) .
> 
> So  in kernel ,  should we need register a undef hook to Get this 
> undef exception and send SIGFPE to user space Process ?

As far as I can see, this can only happen for R-class cores, based on SCTLR.DZ.

Will
