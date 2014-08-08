Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaHHGuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:50:46 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52674 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaHHGum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:50:42 -0400
Date: Thu, 7 Aug 2014 23:50:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: cap1106 - allow changing key mapping from
 userspace
Message-ID: <20140808065038.GC8103@core.coreip.homeip.net>
References: <20140721012045.GA4395@core.coreip.homeip.net>
 <20140807062033.GD651@core.coreip.homeip.net>
 <53E321B0.9040701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E321B0.9040701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 08:50:24AM +0200, Daniel Mack wrote:
> Hi Dmitry,
> 
> On 08/07/2014 08:20 AM, Dmitry Torokhov wrote:
> > On Sun, Jul 20, 2014 at 06:20:49PM -0700, Dmitry Torokhov wrote:
> >> Wire up support for EVIOC{G|S}KEYCODE to allow users change key mappings
> >> from userspace.
> >>
> >> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >> ---
> >>
> >> Just compiled, not tested.
> > 
> > *ping* Any chance you could give it a try? Thanks!
> 
> Oh, sorry, I didn't realize you're waiting for me on this.
> 
> Unfortunately, I can't test it myself anymore, as I had to return the
> board I found this chip on. But as the change looks very straight
> forward, I'd suggest you just apply that patch and I ask the vendor to
> give it a quick try. In case of any problems, I'll let you know. Does
> that sound feasible?

OK, I'll put you down as reviewed-by then so we can share the glory (and the
blame ;))

Thanks.

-- 
Dmitry
