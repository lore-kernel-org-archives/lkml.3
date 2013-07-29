Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3G2VQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab3G2VQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:16:07 -0400
Date: Mon, 29 Jul 2013 17:15:45 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
        airlied@redhat.com, Ben Widawsky <ben@bwidawsk.net>
Subject: Re: i915 debug spew during boot.
Message-ID: <20130729211545.GA27259@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
	airlied@redhat.com, Ben Widawsky <ben@bwidawsk.net>
References: <20130729195431.GA3540@redhat.com>
 <20130729210429.GB27041@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729210429.GB27041@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:04:29PM +0100, Chris Wilson wrote:
 > On Mon, Jul 29, 2013 at 03:54:31PM -0400, Dave Jones wrote:
 > > [    7.542156]  [<ffffffff81079973>] cancel_delayed_work_sync+0x13/0x20
 > > [    7.543020]  [<ffffffff814846ed>] intel_disable_gt_powersave+0x5d/0x420
 > > [    7.543915]  [<ffffffff81486409>] intel_gt_sanitize+0x49/0xb0
 > > [    7.544708]  [<ffffffff81435228>] i915_driver_load+0x608/0xe60
 > 
 > Whoops, we spotted that error and fixed it in the next tree, but forgot
 > to send a fix for stable as well.

note this was Linus' current 3.11-rc3 tree not 3.10.

	Dave

