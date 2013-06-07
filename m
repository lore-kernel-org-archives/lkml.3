Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3FGP7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:59:25 -0400
Received: from 1wt.eu ([62.212.114.60]:36193 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3FGP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:59:24 -0400
Date: Fri, 7 Jun 2013 17:59:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [ 056/184] KVM: x86: relax MSR_KVM_SYSTEM_TIME alignment check
Message-ID: <20130607155919.GM19006@1wt.eu>
References: <20130604172132.630488257@1wt.eu> <1370586735.3693.3.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370586735.3693.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:32:15AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Marcelo Tosatti <mtosatti@redhat.com>
> 
> This was fixed by commit 8f964525a121f2ff2df948dac908dcc65be21b5b
> upstream.  This alternate fix avoids the need for extensive backporting.

Added, thank you Ben.

Willy

