Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaGWS2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:28:08 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52875 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaGWS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:28:06 -0400
Date: Wed, 23 Jul 2014 20:28:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Gouders <dirk@gouders.net>, mmarek@suse.cz
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v3
Message-ID: <20140723182802.GV18735@two.firstfloor.org>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
 <20140720190420.GA4630@ravnborg.org>
 <20140720211901.GQ5803@tassilo.jf.intel.com>
 <20140723180501.GA15749@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723180501.GA15749@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> echo time make -j4 -s KCFLAGS=-gsplit-dwarf
> time make -j4 -s KCFLAGS=-gsplit-dwarf
> echo time make -j4 -s KCFLAGS=-g
> time make -j4 -s KCFLAGS=-g
> echo time make -j4 -s KCFLAGS=-gsplit-dwarf
> time make -j4 -s KCFLAGS=-gsplit-dwarf
> echo time make -j4 -s KCFLAGS=-g
> time make -j4 -s KCFLAGS=-g
> echo time make -j4 -s KCFLAGS=-gsplit-dwarf
> time make -j4 -s KCFLAGS=-gsplit-dwarf
> echo time make -j4 -s KCFLAGS=-g
> time make -j4 -s KCFLAGS=-g
> 
> The figures are from last run - but the other runs had compareable times.
> So in short I see a ~3 seconds speedup - out of 210 seconds.
> Thats less than I anticipated.

Thanks. How much smaller is it? 

Just saving disk space is a good thing.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
