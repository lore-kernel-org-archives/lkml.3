Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaAIQz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:55:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41641 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAIQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:55:51 -0500
Date: Thu, 9 Jan 2014 08:55:41 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Josh Triplett'" <josh@joshtriplett.org>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Dinh Nguyen'" <dinguyen@altera.com>
Subject: Re: [PATCH 1/7] mtd: denali: Drop print of build date/time
Message-ID: <20140109165541.GD28655@norris-Latitude-E6410>
References: <cover.1387833347.git.josh@joshtriplett.org>
 <21175198efaf34a67e5108c1dae384656012b7a0.1387833347.git.josh@joshtriplett.org>
 <000801cf0213$f40bec50$dc23c4f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801cf0213$f40bec50$dc23c4f0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 05:24:53PM +0900, Jingoo Han wrote:
> On Tuesday, December 24, 2013 6:55 AM, Josh Triplett wrote:
> > 
> > The kernel already has this information, and individual drivers
> > shouldn't duplicate that.

BTW, it is possible for modules to be built at a different time than the
kernel, and this code could show that. But it's not very useful anyway,
so I agree.

> > This also eliminates the use of __DATE__ and
> > __TIME__, which make the build non-deterministic.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> (+cc Dinh Nguyen)
> 
> It looks good. :-)
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Thanks. Pushed to l2-mtd.git.

Brian
