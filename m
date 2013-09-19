Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3ISCFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 22:05:07 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:54701 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3ISCFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 22:05:06 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>
CC: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regression: bisected: commit 7c510133d93 breaks video
Thread-Topic: Regression: bisected: commit 7c510133d93 breaks video
Thread-Index: Ac603Dj75+4o5NvZQwiCa9lQKGnjBA==
Date: Thu, 19 Sep 2013 02:02:53 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an ASUS P6X58D-Premium mobo with a GeForce 9400GT PCIe video card.
With kernel 3.12-rc1, I get scrambled video on boot. Kernel 3.11 works
fine.

Bisecting this, I found 7c510133d93dd6f15ca040733ba7b2891ed61fd1 "drm:
mark context support as a legacy subsystem" is the guilty commit. If I
revert that commit, the video works fine.

Is there any more info I can provide?

-- 
Paul

