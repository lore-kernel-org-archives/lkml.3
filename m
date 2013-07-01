Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3GAUb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:31:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43717 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3GAUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:31:54 -0400
Date: Mon, 01 Jul 2013 13:31:53 -0700 (PDT)
Message-Id: <20130701.133153.968451539148790258.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: joe@perches.com, konrad.wilk@oracle.com, jeremy@goop.org,
        xen-devel@lists.xensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH next] xen: Use more current logging styles
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372406390.8976.67.camel@zakaz.uk.xensource.com>
References: <1372395469.2060.36.camel@joe-AO722>
	<1372406390.8976.67.camel@zakaz.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Fri, 28 Jun 2013 08:59:50 +0100

> On Thu, 2013-06-27 at 21:57 -0700, Joe Perches wrote:
>> Instead of mixing printk and pr_<level> forms,
>> just use pr_<level>
>> 
>> Miscellaneous changes around these conversions:
>> 
>> Add a missing newline to avoid message interleaving,
>> coalesce formats, reflow modified lines to 80 columns.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied.
