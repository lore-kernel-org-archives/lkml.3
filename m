Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaG2JKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:10:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaG2JKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:10:17 -0400
Date: Tue, 29 Jul 2014 11:10:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: add additional checks for the existence of
 optional queries in order to compute the address of Query 12.
In-Reply-To: <20140715190702.GB21045@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1407291110090.16390@pobox.suse.cz>
References: <1405114551-24354-1-git-send-email-aduggan@synaptics.com> <20140715190702.GB21045@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Benjamin Tissoires wrote:

> On Jul 11 2014 or thereabouts, Andrew Duggan wrote:
> > There are additional queries which are optional and may not be present depending on the configuration of the firmware. Knowing which queries are present is needed to properly compute the address of Query 12 and all subsequent queries. Additional bits in Query 1 are used to indicate the presence of these optional queries.
> > 
> > Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> > ---
> 
> Looks good to me
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied.

-- 
Jiri Kosina
SUSE Labs
