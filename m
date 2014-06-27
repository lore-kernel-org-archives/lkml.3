Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaF0NhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:37:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbaF0NhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:37:19 -0400
Date: Fri, 27 Jun 2014 15:37:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
In-Reply-To: <20140625223522.GA5923@xo-6d-61-c0.localdomain>
Message-ID: <alpine.LNX.2.00.1406271537000.21386@pobox.suse.cz>
References: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz> <20140514155759.GB9723@amd.pavel.ucw.cz> <20140514182046.GA13342@amd.pavel.ucw.cz> <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz> <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz> <20140607231124.GA3611@amd.pavel.ucw.cz> <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com> <20140609102328.GA25332@amd.pavel.ucw.cz> <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140625223522.GA5923@xo-6d-61-c0.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Pavel Machek wrote:

> Ok, so I have set up machines for ktest / autobisect, and found out that 
> 3.16-rc1 no longer has that problem. Oh well, bisect would not be fun, 
> anyway...

I am still seeing the problem with 3.16-rc2.

-- 
Jiri Kosina
SUSE Labs
