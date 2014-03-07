Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaCGXPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:15:53 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:50285 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752204AbaCGXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:15:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6120:7576:7652:7901:7904:8957:9025:10004:10226:1
X-HE-Tag: side88_157382dfd6229
X-Filterd-Recvd-Size: 2865
Message-ID: <1394234145.16156.109.camel@joe-AO722>
Subject: Re: rfc: checkpatch logical line continuations (was IBM Akebono:
 Add support for a new PHY interface to the IBM emac driver)
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: josh@joshtriplett.org, David Miller <davem@davemloft.net>,
        alistair@popple.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 07 Mar 2014 15:15:45 -0800
In-Reply-To: <20140307230420.GH29018@mwanda>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
	 <1394077948-8395-3-git-send-email-alistair@popple.id.au>
	 <20140307.154142.488351276799532264.davem@davemloft.net>
	 <1394226164.16156.96.camel@joe-AO722> <20140307213017.GA18769@cloud>
	 <20140307230420.GH29018@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 02:04 +0300, Dan Carpenter wrote:
> On Fri, Mar 07, 2014 at 01:30:17PM -0800, josh@joshtriplett.org wrote:
> > On Fri, Mar 07, 2014 at 01:02:44PM -0800, Joe Perches wrote:
> > > On Fri, 2014-03-07 at 15:41 -0500, David Miller wrote:
> > > > From: Alistair Popple <alistair@popple.id.au>
> > > > Date: Thu,  6 Mar 2014 14:52:25 +1100
> > > > 
> > > > > +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> > > > > +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);
> > > > 
> > > > When an expression spans multiple lines, the lines should end with
> > > > operators rather than begin with them.
> > > 
> > > That's not in CodingStyle currently.
> > 
> > It's also not even remotely consistent across existing kernel code, and
> > it isn't obvious that there's a general developer consensus on the
> > "right" way to write it.
> > 
> 
> We just had this discussion in staging and Greg modified the patch to
> put the operator at the end.
> 
> https://lkml.org/lkml/2014/2/25/125

I remember and it's the reason I bring it up in a
more public way.

> It's like logical && and || operators which go at the end these days.
> I don't really want to have a lot of checkpatch churn to convert
> everything...

Nor I really.  I simply would like a tool that lets
more core maintainers like David M avoid sending out
"do this, not that" type emails about patches.

I don't mind adding style checking that emits something
for patches and is quieter when scanning files.



