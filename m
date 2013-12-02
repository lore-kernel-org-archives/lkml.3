Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3LBSzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:55:07 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1051 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3LBSzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:55:03 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Subject: Re: [PATCH] PCI / tg3: Give up chip reset and carrier loss
 handling if PCI device is not present
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: rjw@rjwysocki.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, nsujir@broadcom.com
In-Reply-To: <20131202.134829.2041194874847967680.davem@davemloft.net>
References: <7807315.7cU9KldDtM@vostro.rjw.lan>
 <1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <20131202.134829.2041194874847967680.davem@davemloft.net>
Date: Mon, 2 Dec 2013 10:54:57 -0800
Message-ID: <1386010497.6988.8.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E8208FB15013034180-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 13:48 -0500, David Miller wrote: 
> From: "Michael Chan" <mchan@broadcom.com>
> Date: Sun, 1 Dec 2013 12:39:19 -0800
> 
> > I'm not familiar with the DS1.  Does the tg3 device get removed through
> > tg3_remove_one() in this case?  What happens when you reconnect the DS1?
> 
> Michael, is Rafael's explanation sufficient for you?
> 

Yes, thanks.

Acked-by: Michael Chan <mchan@broadcom.com>


