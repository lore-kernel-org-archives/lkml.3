Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3KTEyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:54:15 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:57656 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3KTExu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:53:50 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Daney <david.daney@cavium.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] ARC: extable: Enable sorting at build time
Thread-Topic: [PATCH] ARC: extable: Enable sorting at build time
Thread-Index: AQHO4c5X1HJl6ervyUaskT5jY/KJ8w==
Date: Wed, 20 Nov 2013 04:53:35 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075156AAE@IN01WEMBXA.internal.synopsys.com>
References: <1384497942-26810-1-git-send-email-vgupta@synopsys.com>
 <C2D7FE5348E1B147BCA15975FBA23075156936@IN01WEMBXA.internal.synopsys.com>
 <528B7D17.7000509@suse.cz>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 08:30 PM, Michal Marek wrote:
> Dne 19.11.2013 12:08, Vineet Gupta napsal(a):
>> Ping ? people OK if I take this via arc tree (after baking it in linux-next for
>> some time).
> It makes more sense to add it to the arc tree than kbuild. If that's
> what you are asking?

Yep, that's what I was asking (and fishing for a ACK or two which I now have
thanks to David).
Patch added to ARC for-curr so it gets a decent -next exposure before sending over
to Linus in 3.13 cycle.

Thx,
-Vineet
