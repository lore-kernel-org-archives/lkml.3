Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaDWQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:25:33 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:49343
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaDWQZc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:25:32 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2 v4] staging: comedi: addi_apci_1564: tidy up
 apci1564_reset()
Thread-Topic: [PATCH 2/2 v4] staging: comedi: addi_apci_1564: tidy up
 apci1564_reset()
Thread-Index: AQHPXsLjHqmMrxCQI0mOscxOlAAzmZsfYVqQ
Date: Wed, 23 Apr 2014 16:25:31 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E1306B@P3PWEX4MB008.ex4.secureserver.net>
References: <1397716383-699-1-git-send-email-chase.southwood@yahoo.com>
 <1398236932.87016.YahooMailNeo@web164006.mail.gq1.yahoo.com>
In-Reply-To: <1398236932.87016.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 12:09 AM, Chase Southwood wrote:
>>On Thursday, April 17, 2014 1:33 AM, Chase Southwood <chase.southwood@yahoo.com> wrote:
>
>> The reset function for this driver is a bit of a mess; clean it up to
>> ensure that it is functioning properly.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> 2: *Changed order of register accesses for digital input registers back to
>> original ordering.
>> *Removed read of digital output status register and reordered the accesses
>> of digital output registers to agree with the order found in addi_apci_2032.
>> *Fixed copy/paste error in the counter register reset lines.
>>
>> 3: *Returned the reset callback to the boardinfo...oops.
>> *Don't write APCI1564_DO_IRQ_REG (it's read only).
>> *Don't clear counter reload values...counters have already been
>> disabled.
>>
>> 4: Leave this in hwdrv_apci1564.c for now (it can be moved after separating
>> this driver from addi_common.c)
>>
>>NB: This patch has been renamed in this version.  It was previously known
>>as "staging: comedi: addi_apci_1564: fixup and absorb apci1564_reset()"
>>
>
>
> Ian and Hartley,
>
> Just following up to see if you have any comments on this version of this patch.
> PATCH 1/2 from this set was added to staging-next today, and I'd like to know
> where this one stands before I work on separating this driver from addi_common.c.
> I'd be happy to make any more changes that are desired, or if it's just better to
> drop the patch for now, that's ok too.  Just want to make sure it's taken care of
> before I move on!

Sorry, I thought I already responded to this...

Looks good now.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

