Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaIYH6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:58:38 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48547 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIYH6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:58:36 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and
 ARC_BOARD_ML509
Thread-Topic: [PATCH] ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and
 ARC_BOARD_ML509
Thread-Index: AQHP1xI53r7Pc5BON0ysEi7+Zq+cjg==
Date: Thu, 25 Sep 2014 07:58:25 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5DE9B6@IN01WEMBXA.internal.synopsys.com>
References: <1401874435.14072.17.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
	 <1410512426.31130.11.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230753C5DA1BE@IN01WEMBXA.internal.synopsys.com>
 <1411465144.20236.21.camel@x220>
 <C2D7FE5348E1B147BCA15975FBA230753C5DE8E6@IN01WEMBXA.internal.synopsys.com>
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

On Thursday 25 September 2014 12:52 PM, Vineet Gupta wrote:
On Tuesday 23 September 2014 03:09 PM, Paul Bolle wrote:

Commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of legacy BVCI latency unit
support") removed the Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that
symbol's entry was the only place were the symbols ARC_BOARD_ANGEL4 and
ARC_BOARD_ML509 were used. So ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 can
be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl><mailto:pebolle@tiscali.nl>
---
Done on top of next-20140923. Tested by grepping the tree only.

Applied to ARC for-next.

Thx Paul,
-Vineet

I did a grep for ARC_BOARD in arch/arc and it seems we have a few stragglers in def configs.
I've pruned them and squashed in same commit.

-Vineet
