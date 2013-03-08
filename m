Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab3CHSCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:02:49 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59925 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933577Ab3CHSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:02:47 -0500
Message-ID: <1362765764.5994.87.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 19:02:44 +0100
In-Reply-To: <20130308175539.GG26093@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
	 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
	 <20130308163507.GC26093@atomide.com>
	 <1362763232.5994.75.camel@x61.thuisdomein>
	 <20130308175539.GG26093@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 18:02:43.0979 (UTC) FILETIME=[21FC05B0:01CE1C27]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 09:55 -0800, Tony Lindgren wrote:
> * Paul Bolle <pebolle@tiscali.nl> [130308 09:24]:
> > Should I draft a patch?
> 
> Sure that would be nice.

One thing I couldn't determine is how the generated mach-types.h header
handles multiple CONFIG_MACH_* macros.

If both CONFIG_MACH_FOO and CONFIG_MACH_BAR are defined, and these both
have a line in */mach-types, will the machine_is_foo() and
machine_is_bar() macros both behave as one would expect?


Paul Bolle

