Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3FGFff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:35:35 -0400
Received: from 1wt.eu ([62.212.114.60]:36089 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:35:34 -0400
Date: Fri, 7 Jun 2013 07:35:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [ 058/184] KVM: x86: invalid opcode oops on SET_SREGS with
Message-ID: <20130607053524.GF14633@1wt.eu>
References: <20130604172132.712738520@1wt.eu> <1370578083.4021.67.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370578083.4021.67.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:08:03AM +0100, Ben Hutchings wrote:
> > Signed-off-by: Petr Matousek <pmatouse@redhat.com>
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > [bwh: Backported to 2.6.32: XSAVE is not supported at all, so always
> >  deny setting OSXSAVE]
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

added, thanks Ben.

Willy

