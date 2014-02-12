Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBLL44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:56:56 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44260 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592AbaBLL4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:56:55 -0500
Message-ID: <1392206214.848.19.camel@hornet>
Subject: Re: [PATCH 02/12] power/reset: vexpress: Use udelay instead of
 timers
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 12 Feb 2014 11:56:54 +0000
In-Reply-To: <201402112159.16758.arnd@arndb.de>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-3-git-send-email-pawel.moll@arm.com>
	 <201402112159.16758.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 20:59 +0000, Arnd Bergmann wrote:
> On Tuesday 11 February 2014, Pawel Moll wrote:
> > At this stage of system shutdown procedure the jiffies may
> > not be updated anymore, so just use udelay instead.
> 
> comment doesn't match code: s/udelay/mdelay/
> 
> > +                       mdelay(1000);
> >         }

Uh, right. Well spotted. Will fix.

Pawel

