Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbaGPBD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:03:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbaGPBDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:03:25 -0400
Date: Tue, 15 Jul 2014 18:07:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 3.15 14/84] serial: imx: Fix build breakage
Message-ID: <20140716010759.GB19997@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
 <20140715231713.621762682@linuxfoundation.org>
 <20140716102414.337e58ce@canb.auug.org.au>
 <20140716004202.GB6908@kroah.com>
 <20140716105656.539105f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716105656.539105f1@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:56:56AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 15 Jul 2014 17:42:02 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jul 16, 2014 at 10:24:14AM +1000, Stephen Rothwell wrote:
> > > 
> > > On Tue, 15 Jul 2014 16:17:11 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > 3.15-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Peter Hurley <peter@hurleysoftware.com>
> > > > 
> > > > commit 8bec751bd63847b4044aab8b215db52aa6abde61 upstream.
> > > > 
> > > > Fix breakage introduced by
> > > > commit c557d392fbf5badd693ea1946a4317c87a26a716,
> > > > 'serial: Test for no tx data on tx restart'.
> > > 
> > > That commit only entered Linus' tree at v3.16-rc5, so this fix
> > > shouldn't need to go into 3.15-stable (unless the original patch was
> > > backported as well - in which case maybe the backport commit id should
> > > be mentioned as well).
> > 
> > c557d392fbf5badd693ea1946a4317c87a26a716, is marked for stable (and is
> > earlier in the series) so leaving this as-is, should be fine, as that
> > commit id will show up in the stable kernels as well in the changelog
> > entry.
> 
> Ah, ok.  So you don't merge "fixes for fixes" to save bisection
> problems, then?  (Just asking)

No I do not, I much prefer to keep the patches identical to what is in
Linus's tree if at all possible.  It saves time overall, so you can
track things better, instead of having to deal with "merged" patches,
which can get messy very quickly.

thanks,

greg k-h
