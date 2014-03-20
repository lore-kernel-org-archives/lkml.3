Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbaCTUpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:45:23 -0400
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:51326 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759883AbaCTUpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:45:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:4250:4321:5007:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13095:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mind92_2e22c830f2237
X-Filterd-Recvd-Size: 2029
Message-ID: <1395348314.7776.47.camel@joe-AO722>
Subject: Re: [PATCH 2/2] coding style: fix line over 80 characters
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: =?ISO-8859-1?Q?C=E9dric?= Cabessa <ced@ryick.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 13:45:14 -0700
In-Reply-To: <532B5ED1.8060406@cogentembedded.com>
References: <1395266697-8699-1-git-send-email-ced@ryick.net>
	 <1395266697-8699-3-git-send-email-ced@ryick.net>
	 <532B5ED1.8060406@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 00:34 +0300, Sergei Shtylyov wrote:
> On 03/20/2014 01:04 AM, Cédric Cabessa wrote:
> > diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
[]
> > @@ -271,12 +271,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
> >   			}
> >   			break;
> >   		case USB_PORT_FEAT_POWER:
> > -			usbip_dbg_vhci_rh(" ClearPortFeature: USB_PORT_FEAT_POWER\n");
> > +			usbip_dbg_vhci_rh(
> > +				" ClearPortFeature: USB_PORT_FEAT_POWER\n");
> 
>     Your version of scripts/checkpatch.pl seems outdated. It shouldn't 
> complain about strings violating 80-column limit (and I've just verified it 
> doesn't).

checkpatch complains about > 80 char lines for lines with
a function where the function name isn't understood to be
a logging use.

uspip_dbg_<foo> doesn't take the general form so if the
string at the EOL exceeds 80 chars, a message is emitted.

Long standalone strings on a single line do not get warnings.


