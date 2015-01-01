Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbbAAVTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:19:06 -0500
Received: from h1.radempa.de ([176.9.142.194]:38285 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbbAAVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:19:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 01 Jan 2015 22:18:56 +0100
From: <harald@ccbib.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, <knaack.h@gmx.de>, <lars@metafoo.de>,
        <pmeerw@pmeerw.net>, <sanjeev_sharma@mentor.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: iio: dht11 Updates
In-Reply-To: <54A53FBF.5000003@kernel.org>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org>
Message-ID: <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, 01 Jan 2015 12:38:23 +0000, Jonathan Cameron <jic23@kernel.org>
wrote:
> On 02/12/14 23:32, Richard Weinberger wrote:
>> Please see my current patches for your driver.
>> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
>> With the IRQ changes I see 84 edges.
>> 
>> 
>> [PATCH 1/4] iio: dht11: Add locking
>> [PATCH 2/4] iio: dht11: IRQ fixes
>> [PATCH 3/4] iio: dht11: Logging updates
>> [PATCH 4/4] iio: dht11: Fix out-of-bounds read
>> 
 
> I've lost track of where we are with this patch series.
> Does this cause trouble on any of the parts supported?

Yes, 2/4 needs an update. 

1/4 is fine by me, however it was noted that there is already
locking in the iio core for the in-kernel interface but not
for the sysfs interface. I think we need locking in the case of
the sysfs interace as well, but the final decision is yours...

4/4 is obviously right.

3/4 is cleanup. I'd rather defer this to later and do it right,
because right now this patch is cosmetic and doesn't get rid of
the deeper issues. I'll start to work on a cleanup series once
the fixes are merged.

Richard, what's your timeframe to send an updated series?
I can send an update if you don't have time.

HTH,
Harald
