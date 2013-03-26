Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab3CZBws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:52:48 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35369 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3CZBwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:52:45 -0400
Date: Mon, 25 Mar 2013 20:52:40 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for
 kernel builds
To: Matt Turner <mattst88@gmail.com>
Cc: Michael Cree <mcree@orcon.net.nz>,
        Tobias Klausmann <klausman@schwarzvogel.de>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
	<BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz>
	<20130325133710.GD14280@mudshark.cambridge.arm.com>
	<20130325150958.GA13894@skade.schwarzvogel.de>
	<D7731577-A2C0-4FC5-A7E3-62F251A18798@orcon.net.nz>
	<CAEdQ38Hx0fbFW615XhhNwv0Spg4pyeqo7BhiOTV-9CrPenPwNQ@mail.gmail.com>
In-Reply-To: <CAEdQ38Hx0fbFW615XhhNwv0Spg4pyeqo7BhiOTV-9CrPenPwNQ@mail.gmail.com>
	(from mattst88@gmail.com on Mon Mar 25 15:55:28 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1364262760.15703.75@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 03:55:28 PM, Matt Turner wrote:
> On Mon, Mar 25, 2013 at 1:06 PM, Michael Cree <mcree@orcon.net.nz>  
> wrote:
> > On 26/03/2013, at 4:09 AM, Tobias Klausmann wrote:
> >>
> >> On Mon, 25 Mar 2013, Will Deacon wrote:
> >>>
> >>> Any news on these? I've included an updated version of the first  
> patch,
> >>> with
> >>> the Tested-by-tag and a tweaked commit message below.
> >>
> >>
> >> As a data point, I tried vanilla 3.8.4 on the weekend. With my
> >> usual config on a UP1500, it will fail at build time with
> >> relocation errors. If I remove -msmall-data (or replace it with
> >> ~big~), the machine hangs hard immediatly after aboot telling me
> >> it's starting it.
> >
> >
> > You probably want the "alpha: Add irongate_io to to PCI bus  
> resources" patch
> > posted by Matt Turner in the linux-alpha forum.  Looks like it has  
> not been
> > sent to Linus.
> >
> > If Matt does not respond in the next day or two I'll collect  
> patches and
> > send them on to Linus.
> 
> Yes, please do. I haven't powered on an alpha in a few months.

What would it take to add Alpha system support to qemu? (It's got  
userspace, but not the system management mode instructions, mmu, or a  
board emulation.)

Rob