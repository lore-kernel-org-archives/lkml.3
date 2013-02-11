Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3BKPcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:32:23 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53358 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3BKPcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:32:22 -0500
Date: Mon, 11 Feb 2013 15:32:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/14] USB: ohci-omap3: Add device tree support and
 binding information
Message-ID: <20130211153217.GB15013@e106331-lin.cambridge.arm.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
 <1360252974-7912-8-git-send-email-rogerq@ti.com>
 <20130211114611.GB2726@e106331-lin.cambridge.arm.com>
 <51190CA7.7010705@ti.com>
MIME-Version: 1.0
In-Reply-To: <51190CA7.7010705@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2013 15:32:18.0242 (UTC) FILETIME=[F9E61A20:01CE086C]
X-MC-Unique: 113021115322100101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +Required properties:
> >> +
> >> +- compatible: should be "ti,ohci-omap3"
> >> +- reg: should contain one register range i.e. start and length
> >> +- interrupt-parent: phandle to the interrupt controller
> > 
> > I'm not sure that needs to be documented as a required property. It's a
> > standard property, and if it's defined for the parent node, you won't need it
> > here.
> 
> The last time I tried without 'interrupt-parent' it complained. Doesn't do it anymore.
> Maybe I did something wrong the last time. I'll remove it.
> 
> > 
> > Otherwise, this looks fine to me.
> 
> Thanks. I'll add your reviewed-by tag after addressing the above comment.

Sure.

Thanks,
Mark.

