Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3GYXS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:18:28 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:36390 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757361Ab3GYXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:18:27 -0400
Date: Thu, 25 Jul 2013 16:18:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] x86: add early quirk for reserving Intel graphics
 stolen memory v3
Message-ID: <20130725161816.45e0471f@jbarnes-desktop>
In-Reply-To: <20130725225925.GD13295@cantiga.alporthouse.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
	<20130725224006.GC13295@cantiga.alporthouse.com>
	<20130725225925.GD13295@cantiga.alporthouse.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 23:59:25 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Hmm, interesting licence block in i915_pciids.h - our claim to
> grant licence but TG disclaims liability.

Oops my manual search & replace obviously failed.  Will fix up.

-- 
Jesse Barnes, Intel Open Source Technology Center
