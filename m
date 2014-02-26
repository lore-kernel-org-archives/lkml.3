Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaBZWhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:37:38 -0500
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:41815 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaBZWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:37:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3867:3868:3870:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7514:7652:7809:9010:9025:9388:10004:10400:10848:11232:11638:11658:11914:12043:12517:12519:12555:12663:12740:13025:13069:13071:13311:13357:13618:13891:13894:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun13_24e61294ba522
X-Filterd-Recvd-Size: 2440
Message-ID: <1393454251.24588.15.camel@joe-AO722>
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock
 Gigabit LAN
From: Joe Perches <joe@perches.com>
To: Keith Packard <keithp@keithp.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        David Miller <davem@davemloft.net>, freddy@asix.com.tw,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 14:37:31 -0800
In-Reply-To: <86mwhd7bt1.fsf@hiro.keithp.com>
References: <87zjle6pif.fsf@nemi.mork.no>
	 <20140226.154801.1466276966991949680.davem@davemloft.net>
	 <87lhwx7f19.fsf@nemi.mork.no>
	 <20140226.161659.2024676575146527914.davem@davemloft.net>
	 <87fvn57dn1.fsf@nemi.mork.no> <86mwhd7bt1.fsf@hiro.keithp.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 14:23 -0800, Keith Packard wrote:
> Bjørn Mork <bjorn@mork.no> writes:
> 
> > No, you didn't.  And when I went looking at it now, I see why: It was
> > posted to linux-usb and linux-kernel but not to netdev:
> > http://www.kernelhub.org/?msg=420289&p=2
> 
> I looked in MAINTAINERS and found linux-usb as a suitable address for
> drivers/net/usb/. I'm sorry I didn't think to look for drivers/net/ as
> well.

Hi Keith.

You could use scripts/get_maintainer.pl next time.

$ ./scripts/get_maintainer.pl -f drivers/net/usb/ax88179_178a.c
"David S. Miller" <davem@davemloft.net> (commit_signer:13/13=100%)
Freddy Xin <freddy@asix.com.tw> (commit_signer:4/13=31%,authored:4/13=31%,added_lines:1473/1504=98%,removed_lines:9/43=21%)
Eric Dumazet <edumazet@google.com> (commit_signer:3/13=23%,authored:2/13=15%,removed_lines:22/43=51%)
Ming Lei <ming.lei@canonical.com> (commit_signer:3/13=23%,authored:3/13=23%,removed_lines:8/43=19%)
David Chang <dchang@suse.com> (commit_signer:2/13=15%,authored:2/13=15%)
Emil Goode <emilgoode@gmail.com> (authored:1/13=8%)
linux-usb@vger.kernel.org (open list:USB NETWORKING DR...)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)


Maybe there should be a MAINTAINERS entry added too?


