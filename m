Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbaD3Jx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:53:29 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:46603 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD3Jx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:53:27 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: ARC patches for stable 3.10
Thread-Topic: ARC patches for stable 3.10
Thread-Index: Ac9kWfuHs1HsNTuISCm1RIcGFPO6OQ==
Date: Wed, 30 Apr 2014 09:53:05 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
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

Hi,

Please apply the following mainline commits to stable 3.10 as prerequisites for a
patch for 3.15/stable which will follow to Linus right after.

147aece29b15051173eb1e767018135361cdba89  (went in 3.11-rc1)
"ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption"

fce16bc35ae4a45634f3dc348d8d297a25c277cf  (went in 3.12-rc1)
"ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE"

Thx,
-Vineet
