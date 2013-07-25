Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3GYXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:01:10 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:59300 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756722Ab3GYXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:01:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 23:59:25 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] x86: add early quirk for reserving Intel graphics
 stolen memory v3
Message-ID: <20130725225925.GD13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
	torvalds@linux-foundation.org
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
 <20130725224006.GC13295@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725224006.GC13295@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, interesting licence block in i915_pciids.h - our claim to
grant licence but TG disclaims liability.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
