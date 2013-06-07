Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3FGP4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:56:15 -0400
Received: from 1wt.eu ([62.212.114.60]:36188 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3FGP4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:56:13 -0400
Date: Fri, 7 Jun 2013 17:55:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [ 049/184] x86/xen: dont assume %ds is usable in xen_iret for
Message-ID: <20130607155558.GL19006@1wt.eu>
References: <20130604172132.342505782@1wt.eu> <1370586528.3693.1.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370586528.3693.1.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:28:48AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  32-bit PVOPS.
> > 
> > From: Jan Beulich <JBeulich@suse.com>
> 
> commit 13d2b4d11d69a92574a55bfd985cfb0ca77aebdc upstream.

Added, thanks Ben.
Willy

