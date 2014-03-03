Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCCMbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 07:31:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48703 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaCCMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 07:31:22 -0500
Date: Mon, 3 Mar 2014 12:31:06 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140303123106.15f7b424@alan.etchedpixels.co.uk>
In-Reply-To: <201403021642.33087.gheskett@wdtv.com>
References: <20140228140043.GA12157@debian.local>
	<20140302205619.GA8676@rhlx01.hs-esslingen.de>
	<20140302210201.GA31948@redhat.com>
	<201403021642.33087.gheskett@wdtv.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We routinely expect 2 to 3 u-s jitters on an Atom board running a 32 bit, 
> RTAI enhanced build of what is by now a 5 year old kernel.  This is 
> extremely board sensitive, and that same kernel running on this 4 core 
> phenom, cannot stay inside of 40 u-s.  A case of more horsepower not being 
> a good deal at all.

Can't speak for AMD devices but I would be curious to know more on the
Intel side about this and how you measured and analysed it.

Are you running with any hyperthreading disabled, a firmware which is not
using SMM, and with any critical code pinned in cache ? How do you have
power management set up ?

(probably best taken off list)

Alan
