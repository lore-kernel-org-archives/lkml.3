Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab3CHRUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:20:36 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:54079 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933860Ab3CHRUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:20:34 -0500
Message-ID: <1362763232.5994.75.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 18:20:32 +0100
In-Reply-To: <20130308163507.GC26093@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
	 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
	 <20130308163507.GC26093@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 17:20:32.0788 (UTC) FILETIME=[3D46ED40:01CE1C21]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 08:35 -0800, Tony Lindgren wrote:
> I think the righ fix is to just add
> 
> config MACH_NOKIA_RM680
> 	bool

I guess you meant MACH_NOKIA_RM696.

> to the mach-omap2/Kconfig like we have for n8x0 also.

Should I draft a patch?


Paul Bolle

