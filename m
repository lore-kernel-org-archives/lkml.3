Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3KVLgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:36:24 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:60899 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755534Ab3KVLgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:36:14 -0500
X-Greylist: delayed 2407 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2013 06:36:14 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 22 Nov 2013 10:55:54 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: airlied <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [i915] BUG: Bad page state in process Xorg
Message-ID: <20131122105554.GK9515@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Meyer <thomas@m3y3r.de>, airlied <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <1384980928.3312.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384980928.3312.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 09:55:28PM +0100, Thomas Meyer wrote:
> Hi,
> 
> I reported this bug a few days ago, but nobody did respond to my bug
> report:
> http://lkml.indiana.edu/hypermail/linux/kernel/1311.2/00058.html
> 
> Every time I restart the X server I will run into this bug with 3.12.0.

I think whilst we scratch our heads wondering about what could cause
corruption in our struct page, we would welcome a bisection. If it dies
during X startup, it would seems like a bisection would progress
quickly. Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
