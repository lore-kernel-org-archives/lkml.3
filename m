Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3A2Sw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:52:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58892 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3A2SwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:52:23 -0500
Date: Tue, 29 Jan 2013 13:52:22 -0500 (EST)
Message-Id: <20130129.135222.864358079580838703.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: Valdis.Kletnieks@vt.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, web10g-user@web10g.org
Subject: Re: Web10g TCP statistics patch - mainlining into kernel?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359481755.4144.4.camel@bwh-desktop.uk.solarflarecom.com>
References: <18855.1359138716@turing-police.cc.vt.edu>
	<1359481755.4144.4.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 29 Jan 2013 17:49:15 +0000

> On Fri, 2013-01-25 at 13:31 -0500, Valdis Kletnieks wrote:
> [...]
>> it's a zero-hit thing for people who don't choose to configure
>> it into their kernel.
> [...]
> 
> People with high-overhead changes always say this, but before long
> distributions will be expected to enable it and then everyone pays the
> price.  So I think you'll have to work on limiting the run-time overhead
> when it's enabled at compile time but the user doesn't care about it.
> Possibly it can be a run-time option?  (I haven't looked at the code and
> don't expect to have time to do so.)

+1

The run time overhead must be zero when the feature is configured into
the kernel, and this requirement is non-negotiable.
