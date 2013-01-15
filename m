Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AOLO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:14:56 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59085 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3AOLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:14:55 -0500
X-Greylist: delayed 64555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 06:14:54 EST
Date: Tue, 15 Jan 2013 11:14:52 +0000
From: Cong Ding <dinggnu@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: drm/nouveau/nouveau_fence.c: remove unnecessary
 null pointer check
Message-ID: <20130115111451.GB27222@gmail.com>
References: <1358210328-16726-1-git-send-email-dinggnu@gmail.com>
 <9706.1358246363@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9706.1358246363@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 10:39:23AM +0000, David Howells wrote:
> Cong Ding <dinggnu@gmail.com> wrote:
> 
> > the variable sender is dereferenced in line 190, so it is no reason to check
> > null again in line 198.
> 
> Did you mean "The variable 'chan'"?
sorry, my fault. so should I send a new version to correct the typo?
- cong

