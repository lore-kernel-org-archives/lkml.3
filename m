Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaKZOlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:41:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39796 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaKZOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:41:10 -0500
Message-ID: <1417012855.3972.3.camel@arm.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>, Mike Turquette <mturquette@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2014 14:40:55 +0000
In-Reply-To: <2667096.evZZoH9ryD@wuerfel>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
	 <1416967146.8358.19.camel@perches.com> <1417003449.3972.1.camel@arm.com>
	 <2667096.evZZoH9ryD@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 12:17 +0000, Arnd Bergmann wrote:
> On Wednesday 26 November 2014 12:04:09 Pawel Moll wrote:
> > 
> > Right, of course. Whole directory.
> > 
> > > F:    */*/vexpress*
> > 
> > Cool, didn't think about multiple wildcards. 
> 
> Actually, I think you could even do this as
> 
> N:	vexpress
> 
> which would be even shorter and match most of the other entries too.

If you think it's safe, fine with me. It would reduce this section to:

N:	vexpress
F:	drivers/clocksource/versatile.c

I'll spin the patch again.

Pawel




