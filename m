Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaJCPR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:17:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46903 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751773AbaJCPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:17:28 -0400
Date: Fri, 3 Oct 2014 17:17:24 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        dan.carpenter@oracle.com, kou.ishizaki@toshiba.co.jp, jens@de.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: spider_net: avoid using signed char for bitops
Message-ID: <20141003151724.GB20398@kwain>
References: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
 <1412348517-20352-4-git-send-email-antoine.tenart@free-electrons.com>
 <9201792.OAu7xPjvdN@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9201792.OAu7xPjvdN@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Oct 03, 2014 at 05:15:05PM +0200, Arnd Bergmann wrote:
> On Friday 03 October 2014 17:01:56 Antoine Tenart wrote:
> > Signedness bugs may occur when using signed char for bitops,
> > depending on if the highest bit is ever used.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > 
> 
> It's probably worth mentioning here that this cannot happen in this
> driver because it's only used in one powerpc-specific chip, and 'char'
> is always 'unsigned' on powerpc.

Oh, that's good to know :)


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
