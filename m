Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaKZMRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:17:35 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:56273 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZMRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:17:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Joe Perches <joe@perches.com>, Mike Turquette <mturquette@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
Date: Wed, 26 Nov 2014 13:17:17 +0100
Message-ID: <2667096.evZZoH9ryD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417003449.3972.1.camel@arm.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com> <1416967146.8358.19.camel@perches.com> <1417003449.3972.1.camel@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qBKJXK3ASIyLN1psgEBjwUMgWSClnNYt183Kj83tHI+
 /w+qdnLulcGy4eJsQahyXdIksLDpegxRXlJDIYJsfXdoiL4tmr
 LebuyrRyRGK4+ftiAee8+a2J88bhk2/eNbENd+HutQpxUjM1A6
 nlj4d1G6ROPSfAeZHyKIO3CKWevScAtc3STopA93rSkQaBEfHt
 PMfYav3Tb9mIEM8VJ7IcEbJlJhre+uAXz19OzkGmR9lVoPJSUS
 HpKxzDWO3qfZBe4s3/e/2upxZpNka8nKQArAN2m9qfB+oKVvNi
 cGAkwvOeHSdZJa1uLucxjJzNmLBY9KVv4EfIYoSVepNYL41vXc
 4yKFCjqHzHokELkPg2Ms=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014 12:04:09 Pawel Moll wrote:
> 
> Right, of course. Whole directory.
> 
> > F:    */*/vexpress*
> 
> Cool, didn't think about multiple wildcards. 

Actually, I think you could even do this as

N:	vexpress

which would be even shorter and match most of the other entries too.

	Arnd
