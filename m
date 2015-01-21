Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbbAUGd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:33:59 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:51607 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbAUGd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:33:57 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Greg KH <greg@kroah.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: stable 3.14 backport request for ARC
Thread-Topic: stable 3.14 backport request for ARC
Thread-Index: AdA1RDjo+lIWBAbqQrCTOgbuEDhnSQ==
Date: Wed, 21 Jan 2015 06:33:52 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCD86E@IN01WEMBXA.internal.synopsys.com>
References: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
 <20150119132617.GA32038@kroah.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 07:03 PM, Greg KH wrote:

On Tue, Dec 23, 2014 at 08:08:51AM +0000, Vineet Gupta wrote:


> 2014-04-18 64ee9f32c33c ARC: Delete stale barrier.h


I don't see how this is an issue for 3.14, it says it fixes a 3.15 build
issue only, so I didn't apply it.  Why did you ask for it?


Technically it was indeed detected in 3.15 but the offending commit was merged in 3.14 (93ea02bb8435 arch: Clean up asm/barrier.h implementations using asm-generic/barrier.h)
I'm ok if you think it doesn't qualify !

FWIW, as an addendum to my prev email I'd also requested for the following backport.
Perhaps you will do that when u eventually get to that email from ur backlog. Otherwise, the details are below.


2014-06-24 ba25915fb2cd ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND

Thx,
-Vineet
