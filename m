Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaIVFRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:17:02 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:34477 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaIVFQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:16:59 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
Thread-Topic: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
Thread-Index: AQHPzmgGRdRrfkg7tEmLvZPmiE0b6w==
Date: Mon, 22 Sep 2014 05:16:54 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5DA1BE@IN01WEMBXA.internal.synopsys.com>
References: <1401874435.14072.17.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
 <1410512426.31130.11.camel@x220>
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

On Friday 12 September 2014 02:30 PM, Paul Bolle wrote:
> Hi Vineet,
>
> On Mon, 2014-06-09 at 09:05 +0000, Vineet Gupta wrote:
>> On Wednesday 04 June 2014 03:04 PM, Paul Bolle wrote:
>>> Linux-next included commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of
>>> legacy BVCI latency unit support") in next-20140604. It removes the
>>> Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that symbol's entry is the
>>> only place were the symbols ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 are
>>> currently used. So it follows that the entries for ARC_BOARD_ANGEL4 and
>>> ARC_BOARD_ML509 could be removed too.
>> Thx for noticing this.
>>
>> I'm planning to use these symbols to set up default builtin DT blobs from Kconfig
>> itself (rather than current defconfigs). If that doesn't workout - sure I will
>> remove the symbols.
> No news here as of v3.17-rc4 and next-20140912. Are you still planning
> to use these symbols or should I submit the trivial patch to drop them?

Please send over patch - I'll queue it up for 3.18

Thx,
-Vineet

>
> Thanks,
>
>
> Paul Bolle
>
>

