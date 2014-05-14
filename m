Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaENVUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:20:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52042 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752285AbaENVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:20:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+tO/2OHIhKupUcPCTUNaYy
Date: Wed, 14 May 2014 14:20:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, george.cherian@ti.com, balbi@ti.com, balajitk@ti.com,
        hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] ARM: OMAP: SATA support for OMAP5 & DRA7
Message-ID: <20140514212006.GG27426@atomide.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
 <5368A0D9.60500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5368A0D9.60500@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140506 01:44]:
> Hi Tony,
> 
> On 04/23/2014 08:30 PM, Roger Quadros wrote:
> > Hi Tony,
> > 
> > These are the pending HWMOD and DTS patches to get SATA working
> > on OMAP5-uevm and DRA7-evm. Please queue them for -next. Thanks.
> 
> gentle reminder. Thanks.

I picked up the .dts changes. Paul is queueing the various hwmod
changes separately.

Regards,

Tony
