Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaDAUqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:46:18 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:60643 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbaDAUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:46:17 -0400
Message-ID: <1396385174.23763.28.camel@x220>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Date: Tue, 01 Apr 2014 22:46:14 +0200
In-Reply-To: <20140401203250.0B2A7C408A6@trevor.secretlab.ca>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail. com>
	 <1396381357.23763.16.camel@x220>
	 <20140401203250.0B2A7C408A6@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 20:46:15.0222 (UTC) FILETIME=[6CA1A560:01CF4DEB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 21:32 +0100, Grant Likely wrote:
> On Tue, 01 Apr 2014 21:42:37 +0200, Paul Bolle <pebolle@tiscali.nl> wrote:
> > That commit leaves a select for PROC_DEVICETREE dangling. See "config
> > ARCH_OMAP2PLUS" in arch/arm/mach-omap2/Kconfig. Can that select
> > statement just be dropped now or is something more elaborate needed?
> 
> I'll fix that up and submit a cleanup today. A dangling select should
> not break the build.

It doesn't, as far as I know. But perhaps the kconfig tools should warn
about select statements for non-existent Kconfig symbols.


Paul Bolle

