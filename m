Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3BMSil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:38:41 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41489 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3BMSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:38:38 -0500
Date: Wed, 13 Feb 2013 19:38:44 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel J Blueman <daniel@quora.org>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
Message-ID: <20130213183844.GB3127@joi.lan>
References: <20130212203417.890993903@linuxfoundation.org>
 <20130212203426.021116247@linuxfoundation.org>
 <1360726523.3642.4.camel@thor.lan>
 <511B5DD0.1040103@broadcom.com>
 <1360748621.10139.0.camel@localhost>
 <20130213174620.GA3127@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213174620.GA3127@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:46:20PM +0100, Marcin Slusarz wrote:
> On Wed, Feb 13, 2013 at 07:43:41PM +1000, Ben Skeggs wrote:
> > On Wed, 2013-02-13 at 10:33 +0100, Arend van Spriel wrote:
> > > On 02/13/2013 04:35 AM, Peter Hurley wrote:
> > > > On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
> > > >> 3.7-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
> > > > I haven't tested this fix either.
> > > 
> > > Dito.
> > > 
> > > Gr. AvS
> > Yeah, I don't believe anything could trigger it in 3.7.  It doesn't hurt
> > anyway.
> 
> Client locking splat is definitely triggerable on 3.7:
> https://lkml.org/lkml/2012/10/16/251
> 
> Subdev locking splat is triggerable since 3.7 has "drm/nouveau: add locking
s/is/should be/

> around instobj list operations" and "drm/nvc0/fb: fix crash when different
> mutex is used to protect same list" (both applied for 3.7.3).
> 
> Marcin
