Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaBQRlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:41:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbaBQRlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:41:12 -0500
Date: Mon, 17 Feb 2014 12:40:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Michael Cree <mcree@orcon.net.nz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH 3.12 117/133] alpha: fix broken network checksum
In-Reply-To: <20140206043833.GA12599@omega>
Message-ID: <alpine.LRH.2.02.1402171240090.8698@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140204210737.008598235@linuxfoundation.org> <20140204210740.336662867@linuxfoundation.org> <20140206043833.GA12599@omega>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Feb 2014, Michael Cree wrote:

> On Tue, Feb 04, 2014 at 01:08:38PM -0800, Greg Kroah-Hartman wrote:
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > commit 0ef38d70d4118b2ce1a538d14357be5ff9dc2bbd upstream.
> > 
> > The patch 3ddc5b46a8e90f3c9251338b60191d0a804b0d92 breaks networking on
> > alpha (there is a follow-up fix 5cfe8f1ba5eebe6f4b6e5858cdb1a5be4f3272a6,
> > but networking is still broken even with the second patch).
> 
> I wonder whether that follow-up (partial) fix mentioned
> (5cfe8f1ba5eebe6f4b6e5858cdb1a5be4f3272a6) should be pulled into 3.12 stable
> too?
> 
> Cheers
> Michael.

I think it doesn't have to be backported.

Mikulas
