Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546Ab3FTNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:12:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45421 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398Ab3FTNMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:12:34 -0400
Date: Thu, 20 Jun 2013 22:12:32 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: Alexander Frolkin <avf@eldamar.org.uk>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: sloppy TCP and SCTP
Message-ID: <20130620131232.GB24993@verge.net.au>
References: <20130612104754.GA29327@eldamar.org.uk>
 <20130613075615.GA29773@eldamar.org.uk>
 <alpine.LFD.2.00.1306131121470.1680@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306131121470.1680@ja.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:32:11AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 13 Jun 2013, Alexander Frolkin wrote:
> 
> > This adds support for sloppy TCP and SCTP modes to IPVS.
> > 
> > When enabled (sysctls net.ipv4.vs.sloppy_tcp and
> > net.ipv4.vs.sloppy_sctp), allows IPVS to create connection state on any
> > packet, not just a TCP SYN (or SCTP INIT).
> > 
> > This allows connections to fail over from one IPVS director to another
> > mid-flight.
> > 
> > Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>
> 
> 	Thanks! Simon, please apply to ipvs-next tree!

Done :)

> Signed-off-by: Julian Anastasov <ja@ssi.bg>
