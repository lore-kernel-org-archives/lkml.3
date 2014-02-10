Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaBJXGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:06:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:06:16 -0500
Date: Mon, 10 Feb 2014 15:06:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] mm/zswap: add writethrough option
Message-Id: <20140210150614.c6a1b20553803da5f81acb72@linux-foundation.org>
In-Reply-To: <CALZtONAFF3F4j0KQX=ineJ1cOVEWJSGSe3V=Ja4x=3NguFAFMQ@mail.gmail.com>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
	<1390831279-5525-1-git-send-email-ddstreet@ieee.org>
	<20140203150835.f55fd427d0ebb0c2943f266b@linux-foundation.org>
	<CALZtONAFF3F4j0KQX=ineJ1cOVEWJSGSe3V=Ja4x=3NguFAFMQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 14:05:14 -0500 Dan Streetman <ddstreet@ieee.org> wrote:

> >
> > It does sound like the feature is of marginal benefit.  Is "zswap
> > filled up" an interesting or useful case to optimize?
> >
> > otoh the addition is pretty simple and we can later withdraw the whole
> > thing without breaking anyone's systems.
> 
> ping...
> 
> you still thinking about this or is it a reject for now?

I'm not seeing a compelling case for merging it and Minchan sounded
rather unconvinced.  Perhaps we should park it until/unless a more
solid need is found?

