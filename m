Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaKJFxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:53:04 -0500
Received: from smtprelay4.synopsys.com ([198.182.44.111]:40590 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaKJFxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:53:01 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Igor Guryanov <Igor.Guryanov@synopsys.com>
Subject: Re: [arc-linux-dev] Re: ARC backport for stable 3.14
Thread-Topic: [arc-linux-dev] Re: ARC backport for stable 3.14
Thread-Index: AQHP/JX42s+xQ5c/9Uq3SmY/HBFJ7Q==
Date: Mon, 10 Nov 2014 05:52:56 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BA8F83@IN01WEMBXA.internal.synopsys.com>
References: <C2D7FE5348E1B147BCA15975FBA230753C5E6418@IN01WEMBXA.internal.synopsys.com>
 <20141110023032.GA13024@kroah.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014 08:55 AM, Greg Kroah-Hartman wrote:
> On Wed, Oct 15, 2014 at 09:26:55AM +0000, Vineet Gupta wrote:
>> Hi,
>>
>> Can you please apply the following mainline commits to 3.14 stable (in the order below)
>>
>> c3441edd2dea ARC: [SMP] General Fixes
> That commit doesn't have a signed-off-by:, what happened?

Not sure how I missed that in first place ?

>
>> d75386363ee6 ARC: fix mmuv2 warning
>> ef680cdc2437 ARC: Disable caches in early boot if so configured
>>
>> Build/run tested on 3.14
> All applied now, thanks.
>
> greg k-h
>

