Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3GIHzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:55:44 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:8576 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3GIHzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:55:42 -0400
Date: Tue, 9 Jul 2013 09:55:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, linux@arm.linux.org.uk,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Matthew Longnecker <MLongnecker@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [lm-sensors] [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for
  lm90
Message-ID: <20130709095525.5158a0a5@endymion.delvare>
In-Reply-To: <51DBC058.2040904@nvidia.com>
References: <1372928979-26938-1-git-send-email-wni@nvidia.com>
	<1372928979-26938-2-git-send-email-wni@nvidia.com>
	<51D70483.70203@wwwdotorg.org>
	<51DA6BD4.1040300@nvidia.com>
	<20130708095024.041a6d57@endymion.delvare>
	<51DA8805.50709@nvidia.com>
	<20130708131421.GB21638@roeck-us.net>
	<20130709062112.GC17499@mithrandir>
	<51DBC058.2040904@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013 15:48:40 +0800, Wei Ni wrote:
> On 07/09/2013 02:21 PM, Thierry Reding wrote:
> > It should work out of the box. As a matter of fact the same chip is used
> > on Tamonten and the DTS files use "onnn,nct1008". That used to work. If
> > it no longer does then that's a regression.
> 
> I synced the linux-next from:
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> and use the tag v3.10-rc7, but in the lm90.c it doesn't have DT support,
> such as "onnn,nct1008".
> I googled it and found there has patch:
> [PATCH] hwmon: (lm90) Add device tree support , which is in:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2013-February/038099.html
> , but it didn't be merged into the linux-next.

It was not, because of the next reply in the same thread:
http://lists.lm-sensors.org/pipermail/lm-sensors/2013-February/038100.html

> which git repository and branch should I use ?

It is supposed to just work. What doesn't work for you exactly?

-- 
Jean Delvare
