Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3BDUyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:54:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35675 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3BDUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:54:18 -0500
Date: Mon, 4 Feb 2013 12:53:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Amit Kale <akale@stec-inc.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
Message-ID: <20130204205339.GI4761@blackbox.djwong.org>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <20130204144016.GA2522@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204144016.GA2522@raspberrypi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 02:40:17PM +0000, thornber@redhat.com wrote:
> On Fri, Feb 01, 2013 at 04:44:59PM -0800, Darrick J. Wong wrote:
> > I will start reviewing the code as soon as this patch posts.  Be warned that I
> > haven't even compile tested this yet. :)
> 
> Has the code been updated since I looked at it a couple of weeks ago?
> For example addressing all the 'sparse' warnings?
> 
> If you've not compiled or reviewed this code, what do you mean by the
> 'signed-off by' tag?

I changed a couple of things in the Kconfig file, most notably setting default
to n and depending on BLK_DEV.

--D
> 
> - Joe
