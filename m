Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaH3Svx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:51:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaH3Svw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:51:52 -0400
Date: Sat, 30 Aug 2014 11:51:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] lustre: Add MAINTAINERS entry
Message-ID: <20140830185150.GA24711@kroah.com>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
 <1408121295-29115-10-git-send-email-green@linuxhacker.ru>
 <20140817163739.GA15982@kroah.com>
 <980AF87D-E1F4-4C0E-AFF3-DB170DB98ADA@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <980AF87D-E1F4-4C0E-AFF3-DB170DB98ADA@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:47:57PM -0400, Oleg Drokin wrote:
> 
> On Aug 17, 2014, at 12:37 PM, Greg Kroah-Hartman wrote:
> 
> > On Fri, Aug 15, 2014 at 12:48:14PM -0400, Oleg Drokin wrote:
> >> Just add the entry with some info.
> >> 
> >> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> >> ---
> >> MAINTAINERS | 8 ++++++++
> >> 1 file changed, 8 insertions(+)
> >> 
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 7e2eb4c..369183b 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -8646,6 +8646,14 @@ W:	http://www.lirc.org/
> >> S:	Odd Fixes
> >> F:	drivers/staging/media/lirc/
> >> 
> >> +STAGING - LUSTRE PARALLEL FILESYSTEM
> >> +M:	Oleg Drokin <oleg.drokin@intel.com>
> >> +M:	Andreas Dilger <andreas.dilger@intel.com>
> >> +L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)
> > 
> > I _really_ hate moderated mailing lists for kernel development stuff.
> > Why not just use the driverdev mailing list instead?
> 
> I guess this could be done if we really need to, but ...
> 
> > I note that you didn't even cc: this patch series to that list...
> 
> The instructions in the beginning of the file say:
> "L: Mailing list that is relevant to this area"
> This is the mailing list that is relevant to the area, but we don't really send patches in there,
> and because it's premoderated it's not really convenient anyway as you rightly notice.
> People can ask other questions they might have bout their problems there, though, and there's
> a higher chance that somebody familiar with lustre will read and answer them.
> 
> the 'M:' is the send patches to according to the instructions?

Yes, this is correct, but watch out, this isn't going to keep patches
from being sent to the driverdevel mailing list and me applying them
directly.

Personally, I'll never cc: your hpdd mailing list, as I get bounces from
it, and don't feel that kernel mailing lists should ever be "closed"
(I run an open kernel mailing list, it can be done, and isn't all that
hard...)

So I'll go apply this, but don't really like it...

greg k-h
