Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaEGRU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:20:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50296 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEGRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:20:23 -0400
Date: Wed, 07 May 2014 13:20:21 -0400 (EDT)
Message-Id: <20140507.132021.591444790908478214.davem@davemloft.net>
To: gnomes@lxorguk.ukuu.org.uk
Cc: tom.zanussi@linux.intel.com, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140507145938.79110827@alan.etchedpixels.co.uk>
References: <20140505.232327.578134514220748085.davem@davemloft.net>
	<1399351148.8767.84.camel@empanada>
	<20140507145938.79110827@alan.etchedpixels.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 07 May 2014 10:20:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Date: Wed, 7 May 2014 14:59:38 +0100

> 16MB of DRAM means adding a chip to your system. You've just exceeded the
> space, power and cost budget on the very low end. In many cases like FPGA
> systems you can't even add DRAM without major hoop jumping.

A year or so for now this may not be true, which makes these kinds of changes
very nearly in the "point in time solution" category.

My main point in all of this is that whilst Linux should work on a braod range
of system types, there has to be a limit somewhere and I think 2MB is off
the deep end.
