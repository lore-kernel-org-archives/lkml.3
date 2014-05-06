Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaEFRZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:25:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaEFRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:25:04 -0400
Date: Tue, 06 May 2014 13:25:01 -0400 (EDT)
Message-Id: <20140506.132501.331724703594119414.davem@davemloft.net>
To: josh@joshtriplett.org
Cc: eric.dumazet@gmail.com, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506172106.GB20776@cloud>
References: <20140506164546.GB20536@cloud>
	<20140506.131752.740569380523989782.davem@davemloft.net>
	<20140506172106.GB20776@cloud>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 10:25:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: josh@joshtriplett.org
Date: Tue, 6 May 2014 10:21:06 -0700

> On Tue, May 06, 2014 at 01:17:52PM -0400, David Miller wrote:
>> From: josh@joshtriplett.org
>> Date: Tue, 6 May 2014 09:45:46 -0700
>> 
>> > The kernel can do the same.  Consider the idea of analyzing a set of
>> > userspace programs, determining what kernel functionality they do and
>> > don't need, feeding that information into the kernel build process, and
>> > automatically dropping unused bits of the kernel.
>> 
>> Please make sure I'm not on the list of people who see reports for
>> bugs reported in that setup.
>> 
>> Thanks :-)
> 
> Fine by me.  Just please allow such a setup to exist. :)

You see, that's the point I'm trying to make, once it's upstream
then it's my problem.

You absolutely must consider the burdon you put upon upstream
maintainers when you ask for things to be included.
