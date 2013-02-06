Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3BFAiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:38:46 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:48018 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3BFAin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:38:43 -0500
Date: Wed, 6 Feb 2013 09:38:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Joerg Roedel <joro@8bytes.org>, Hideki EIRAKU <hdk@igel.co.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/4] Renesas IPMMU driver for sh7372, sh73a0 and
 r8a7740
Message-ID: <20130206003840.GA20881@verge.net.au>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
 <20130201135633.GH25591@8bytes.org>
 <20130201140927.GA12216@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201140927.GA12216@linux-sh.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:09:28PM +0900, Paul Mundt wrote:
> On Fri, Feb 01, 2013 at 02:56:33PM +0100, Joerg Roedel wrote:
> > On Mon, Jan 21, 2013 at 07:54:25PM +0900, Hideki EIRAKU wrote:
> > > Hideki EIRAKU (4):
> > >   iommu/shmobile: Add iommu driver for Renesas IPMMU modules
> > >   ARM: mach-shmobile: sh7372: Add IPMMU device
> > >   ARM: mach-shmobile: sh73a0: Add IPMMU device
> > >   ARM: mach-shmobile: r8a7740: Add IPMMU device
> > 
> > Paul, Magnus, any opinions on patches 2-4? Can you ACK them when they
> > are ok for you?
> > 
> No strong opinions one way or the other, patches 2-4 don't really do
> anything of significance.
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Likewise. shmobile patches:

Acked-by: Simon Horman <horms+renesas@verge.net.au>

