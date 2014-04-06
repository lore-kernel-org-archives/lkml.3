Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaDFR2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:28:42 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:62960 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbaDFR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:28:37 -0400
Message-ID: <1396805315.7723.8.camel@x220>
Subject: Re: Kconfig ARM_ERRATA_753970?
From: Paul Bolle <pebolle@tiscali.nl>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Date: Sun, 06 Apr 2014 19:28:35 +0200
In-Reply-To: <53418889.2050002@free-electrons.com>
References: <201404052101.19381.arnd@arndb.de>
		 <201404052104.11363.arnd@arndb.de> <1396777049.30640.9.camel@x220>
	 <53418889.2050002@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 17:28:36.0227 (UTC) FILETIME=[A42F5D30:01CF51BD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 19:02 +0200, Gregory CLEMENT wrote:
> Yes it is correct. ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970
> in kernel 3.2. 

Thanks! That was commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up
Kconfig options for PL310 errata workarounds"), by the way. I hadn't
checked the history of the tree. Had I bothered to do so this all would
have been less mysterious.

> I had just carry on the symbol name without noticed that
> it have changed.
> 
> Do you want to send a fix, or do you prefer I take care of it?

It is a trivial fix, but it might need some testing, which I can't do.
So I guess it's easiest if you take care of it.


Paul Bolle

