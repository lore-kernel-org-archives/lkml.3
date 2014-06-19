Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbaFSUZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:25:23 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:41756 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755026AbaFSUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:25:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:133
X-HE-Tag: bell29_4b92291ca8125
X-Filterd-Recvd-Size: 1981
Message-ID: <1403209518.2753.4.camel@joe-AO725>
Subject: Re: [PATCH 5/8] wlan-ng/prism2mib:checkpatch: Insert blank lines
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 13:25:18 -0700
In-Reply-To: <20140619201459.GD16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
	 <1403205620-10219-5-git-send-email-Johannes.Stadlinger@fau.de>
	 <20140619201459.GD16404@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 13:14 -0700, josh@joshtriplett.org wrote:
> On Thu, Jun 19, 2014 at 09:20:17PM +0200, Johannes Stadlinger wrote:
> > This patch inserts blank lines after declarations to avoid checkpatch
> > warning.
[]
> > diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
[]
> > @@ -85,7 +85,8 @@ struct mibrec {
> >  	u16 parm1;
> >  	u16 parm2;
> >  	u16 parm3;
> > -	int (*func) (struct mibrec *mib,
> > +
> > +	int (*func)(struct mibrec *mib,
> 
> Eliminating the space here makes sense, but checkpatch shouldn't warn
> about spaces after declarations between two fields in the middle of a
> structure declaration.

It's a defect in checkpatch,
It's fixed in the latest version in -next

https://lkml.org/lkml/2014/6/6/426


