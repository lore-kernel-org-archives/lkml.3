Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaIYHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:25:27 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:48205 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaIYHZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:25:26 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Remove unneeded Kconfig entry NO_DMA
Thread-Topic: [PATCH] ARC: Remove unneeded Kconfig entry NO_DMA
Thread-Index: AQHP2CXlQwODgb/mqEuPy94ysmGqHA==
Date: Thu, 25 Sep 2014 07:25:22 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5DE8F3@IN01WEMBXA.internal.synopsys.com>
References: <1411583542.19525.22.camel@x220>
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

On Thursday 25 September 2014 12:02 AM, Paul Bolle wrote:

Architectures only need a Kconfig entry for NO_DMA if it is possible
that its value will be 'y'. For arc its value will always be 'n', making
it pointless. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl><mailto:pebolle@tiscali.nl>

Applied to ARC for-next.

Thx Paul,
-Vineet
