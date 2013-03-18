Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3CRG5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 02:57:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:60872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3CRG5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 02:57:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,862,1355126400"; 
   d="scan'208";a="280893589"
Message-ID: <1363589936.20738.6.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: remove ixp2000 driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 08:58:56 +0200
In-Reply-To: <1363214471.1335.19.camel@x61.thuisdomein>
References: <1363206974.1335.10.camel@x61.thuisdomein>
	 <1363214471.1335.19.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 23:41 +0100, Paul Bolle wrote:
> On Wed, 2013-03-13 at 21:36 +0100, Paul Bolle wrote:
> > Support for the IXP2000 platform got removed in commit
> > c65f2abf54a6d07260f1fa64773154e1d7047961 ("ARM: remove ixp23xx and
> > ixp2000 platforms"). That commit removed the ARCH_IXP2000 Kconfig
> > symbol. This removes the last driver depending on that symbol.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> It turns out that Artem Bityutskiy has published a series of patches
> removing this and similar drivers just yesterday:
> http://lists.infradead.org/pipermail/linux-mtd/2013-March/046170.html 

Hi,

yes, this mtd driver is removed now, thanks!

-- 
Best Regards,
Artem Bityutskiy

