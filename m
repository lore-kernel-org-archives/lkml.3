Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaGWHnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:43:33 -0400
Received: from sym2.noone.org ([178.63.92.236]:53378 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbaGWHn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:43:29 -0400
Date: Wed, 23 Jul 2014 09:43:26 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mailbox/omap: Use module_platform_driver
Message-ID: <20140723074326.GA16456@distanz.ch>
References: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
 <53CE7C9C.6060107@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CE7C9C.6060107@ti.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-22 at 17:00:44 +0200, Suman Anna <s-anna@ti.com> wrote:
> Hi Tobias,
> 
> On 07/22/2014 07:13 AM, Tobias Klauser wrote:
> > Use the module_platform_driver to omit module init/exit boilerplate code.
> > 
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > ---
> >  drivers/mailbox/mailbox-omap1.c | 13 +------------
> >  drivers/mailbox/mailbox-omap2.c | 13 +------------
> >  2 files changed, 2 insertions(+), 24 deletions(-)
> 
> I have submitted a series that cleans up/consolidates the OMAP mailbox
> driver [1], and this patch won't be necessary as the same lines get deleted.

Ah, I wasn't aware of this series. Should do my homework better next
time ;) Sorry for the noise.

Thanks
Tobias
