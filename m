Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185Ab3BAOKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:10:19 -0500
Received: from linux-sh.org ([111.68.239.195]:54267 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab3BAOKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:10:16 -0500
Date: Fri, 1 Feb 2013 23:09:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Hideki EIRAKU <hdk@igel.co.jp>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/4] Renesas IPMMU driver for sh7372, sh73a0 and
 r8a7740
Message-ID: <20130201140927.GA12216@linux-sh.org>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
 <20130201135633.GH25591@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201135633.GH25591@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:56:33PM +0100, Joerg Roedel wrote:
> On Mon, Jan 21, 2013 at 07:54:25PM +0900, Hideki EIRAKU wrote:
> > Hideki EIRAKU (4):
> >   iommu/shmobile: Add iommu driver for Renesas IPMMU modules
> >   ARM: mach-shmobile: sh7372: Add IPMMU device
> >   ARM: mach-shmobile: sh73a0: Add IPMMU device
> >   ARM: mach-shmobile: r8a7740: Add IPMMU device
> 
> Paul, Magnus, any opinions on patches 2-4? Can you ACK them when they
> are ok for you?
> 
No strong opinions one way or the other, patches 2-4 don't really do
anything of significance.

Acked-by: Paul Mundt <lethal@linux-sh.org>
