Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab3BMRqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:46:20 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47594 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab3BMRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:46:18 -0500
Date: Wed, 13 Feb 2013 18:46:20 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel J Blueman <daniel@quora.org>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
Message-ID: <20130213174620.GA3127@joi.lan>
References: <20130212203417.890993903@linuxfoundation.org>
 <20130212203426.021116247@linuxfoundation.org>
 <1360726523.3642.4.camel@thor.lan>
 <511B5DD0.1040103@broadcom.com>
 <1360748621.10139.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360748621.10139.0.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 07:43:41PM +1000, Ben Skeggs wrote:
> On Wed, 2013-02-13 at 10:33 +0100, Arend van Spriel wrote:
> > On 02/13/2013 04:35 AM, Peter Hurley wrote:
> > > On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
> > >> 3.7-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
> > > I haven't tested this fix either.
> > 
> > Dito.
> > 
> > Gr. AvS
> Yeah, I don't believe anything could trigger it in 3.7.  It doesn't hurt
> anyway.

Client locking splat is definitely triggerable on 3.7:
https://lkml.org/lkml/2012/10/16/251

Subdev locking splat is triggerable since 3.7 has "drm/nouveau: add locking
around instobj list operations" and "drm/nvc0/fb: fix crash when different
mutex is used to protect same list" (both applied for 3.7.3).

Marcin
