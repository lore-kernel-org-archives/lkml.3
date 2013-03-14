Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3CNIAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:00:23 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52812 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab3CNIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:00:21 -0400
Message-ID: <1363248014.1335.23.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 09:00:14 +0100
In-Reply-To: <20130311163351.GJ26093@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
	 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
	 <20130308163507.GC26093@atomide.com>
	 <1362763232.5994.75.camel@x61.thuisdomein>
	 <20130308175539.GG26093@atomide.com>
	 <1362765764.5994.87.camel@x61.thuisdomein>
	 <20130309000157.GE30923@n2100.arm.linux.org.uk>
	 <1362858510.3137.31.camel@x61.thuisdomein>
	 <20130311163351.GJ26093@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 08:00:15.0046 (UTC) FILETIME=[F6051660:01CE2089]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 09:33 -0700, Tony Lindgren wrote:
> * Paul Bolle <pebolle@tiscali.nl> [130309 11:52]:
> > In the meantime, how do you prefer I solve the (trivial) issue of an
> > useless select for MACH_NOKIA_RM696? Drop that select or add an (equally
> > useless) config entry for MACH_NOKIA_RM696? Or should I try to ignore it
> > for the time being?
> 
> Just adding the config MACH_NOKIA_RM696 to Kconfig as bool should fix
> this unless I'm missing something here.

Yes, that should do. I already promised to draft that small patch last
week. I hope to actually do that shortly.


Paul Bolle

