Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3CXN5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:57:11 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:40424 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3CXN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:57:10 -0400
Date: Sun, 24 Mar 2013 15:57:06 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/nouveau: fix NULL ptr dereference from
 nv50_disp_intr()
Message-ID: <20130324135705.GJ14155@blackmetal.musicnaut.iki.fi>
References: <1363705988.3413.17.camel@thor.lan>
 <1364039260.3440.5.camel@thor.lan>
 <514EE9EE.9030208@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514EE9EE.9030208@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 24, 2013 at 12:56:30PM +0100, Maarten Lankhorst wrote:
> Op 23-03-13 12:47, Peter Hurley schreef:
> > On Tue, 2013-03-19 at 11:13 -0400, Peter Hurley wrote:
> >> On vanilla 3.9.0-rc3, I get this 100% repeatable oops after login when
> >> the user X session is coming up:
> > Perhaps I wasn't clear that this happens on every boot and is a
> > regression from 3.8
> >
> > I'd be happy to help resolve this but time is of the essence; it would
> > be a shame to have to revert all of this for 3.9
> 
> Well it broke on my system too, so it was easy to fix.
> 
> I didn't even need gdm to trigger it!
> 
> >8----
> This fixes regression caused by 1d7c71a3e2f7 (drm/nouveau/disp: port vblank handling to event interface),

This patch fixes the boot crashes also on my G5 iMac
(http://marc.info/?l=linux-kernel&m=136285469916031&w=2).

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

A.
