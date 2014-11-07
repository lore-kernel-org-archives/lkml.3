Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaKGXJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:09:41 -0500
Received: from www17.your-server.de ([213.133.104.17]:41024 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaKGXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:09:40 -0500
Message-ID: <1415401776.2767.1.camel@localhost.localdomain>
Subject: [PATCH] netfilter: fix compile of nft_reject_bridge
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 08 Nov 2014 00:09:36 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Von: Stephen Hemminger <stephen@networkplumber.org>
> An: Thomas Meyer <thomas@m3y3r.de>
> Betreff: Re: [PATCH] netfilter: fix compile of nft_reject_bridge
> Datum: Mon, 3 Nov 2014 12:44:06 -0800
> 
> On Sat, 01 Nov 2014 16:21:39 +0100
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > Module uses csum_ipv6_magic(), so include the correct header file.
> > 
> > Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> > ---
> > 
> > diff --git a/net/bridge/netfilter/nft_reject_bridge.c
b/net/bridge/netfilter/nft_reject_bridge.c
> > index 654c901..1123f2b 100644
> > --- a/net/bridge/netfilter/nft_reject_bridge.c
> > +++ b/net/bridge/netfilter/nft_reject_bridge.c
> > @@ -16,6 +16,7 @@
> >  #include <net/netfilter/nft_reject.h>
> >  #include <net/netfilter/ipv4/nf_reject.h>
> >  #include <net/netfilter/ipv6/nf_reject.h>
> > +#include <net/ip6_checksum.h>
> >  #include <linux/ip.h>
> >  #include <net/ip.h>
> >  #include <linux/netfilter_bridge.h>
> > 
> > 
> 
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>


