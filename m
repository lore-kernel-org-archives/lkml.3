Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaFIJGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:06:47 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:50667 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaFIJFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:05:33 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
Thread-Topic: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
Thread-Index: AQHPf9geWmcdGdQwOEyH5yqHHdSEMg==
Date: Mon, 9 Jun 2014 09:05:25 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
References: <1401874435.14072.17.camel@x220>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wednesday 04 June 2014 03:04 PM, Paul Bolle wrote:
> Hi Vineet,
>
> Linux-next included commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of
> legacy BVCI latency unit support") in next-20140604. It removes the
> Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that symbol's entry is the
> only place were the symbols ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 are
> currently used. So it follows that the entries for ARC_BOARD_ANGEL4 and
> ARC_BOARD_ML509 could be removed too.

Thx for noticing this.

I'm planning to use these symbols to set up default builtin DT blobs from Kconfig
itself (rather than current defconfigs). If that doesn't workout - sure I will
remove the symbols.

Thx,
-Vineet

>
> If that's correct: is the trivial patch to remove the Kconfig entries
> for ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 queued somewhere?
>
>
> Paul Bolle
>
>

