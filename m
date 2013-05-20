Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab3ETTIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:08:50 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49271 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754154Ab3ETTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:08:48 -0400
Date: Mon, 20 May 2013 22:08:32 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Ben Hutchings <bhutchings@solarflare.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: moving constant and
 structure definitions out of rtl8150.c
In-Reply-To: <1369061360.4616.0.camel@bwh-desktop.uk.solarflarecom.com>
Message-ID: <alpine.DEB.2.02.1305202158520.3400@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305182306550.16874@fry.nucleusys.com> <1369061360.4616.0.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013, Ben Hutchings wrote:

> Now how is this driver going to compile, when rtl8150.h is only added by
> the next patch?!

I got carried away by the desire to make each patch smaller and to the 
point.  Sacrificing build-ability of the tree, however, does not justify 
it.  My bad.

> You need to squash these first 2 together, so that the driver can be
> compiled after each step.

Will do once David merge 'net' into 'net-next'.


		Petko
