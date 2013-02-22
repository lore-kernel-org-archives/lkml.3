Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3BVRod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:44:33 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:35824 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3BVRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:44:32 -0500
X-IronPort-AV: E=Sophos;i="4.84,717,1355097600"; 
   d="scan'208";a="1797026"
Message-ID: <1361555068.26546.144.camel@zakaz.uk.xensource.com>
Subject: Re: xen-netback fixes for stable 35876b5 3e55f8b
From: Ian Campbell <Ian.Campbell@citrix.com>
To: William Dauchy <william@gandi.net>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Date: Fri, 22 Feb 2013 17:44:28 +0000
In-Reply-To: <20130222164728.GB27794@gandi.net>
References: <20130222164728.GB27794@gandi.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Dave Miller, the networking maintainer. He needs to ack such
requests I think. Adding netdev too for good meassure.

On Fri, 2013-02-22 at 16:47 +0000, William Dauchy wrote:
> Hello,
> 
> I believe the two commits 35876b5 and 3e55f8b could be included in stable tree.
> 35876b5 is related to 4885628 already in the stable tree and fixes a
> possible oops.
> 3e55f8b is fixing another possible oops (see commit messages).

DaveM has these queued for stable already:
http://marc.info/?l=xen-devel&m=136086628711282&w=2

He likes to soak thing in mainline for a bit before forwarding to stable
which is likely why they aren't there yet
http://marc.info/?l=xen-devel&m=136029801624783&w=2

Ian.

