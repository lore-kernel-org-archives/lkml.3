Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaELSAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:00:36 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:14205 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbaELSAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:00:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUSAOsLcVNbsHLF/2dsb2JhbABZgwaCQaoyAQUBmhEEBAIBgRkXdIIlAQEEATocIwULCAMYGQITOR4GE4g5DAHPNReFVoh8BycChBcBA5lHAYsEiAODODuBFB4
Date: Mon, 12 May 2014 20:00:33 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
Message-Id: <20140512200033.87712053add71ca2cf35fe79@skynet.be>
In-Reply-To: <1399917025.9240.16.camel@joe-AO725>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
	<1399917025.9240.16.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 10:50:25 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-12 at 19:30 +0200, Fabian Frederick wrote:
> > This patch also fixes some comment checkpatch warnings
> 
> Hello Fabian.
> 
> For all the patches that replace memcpy(foo, bar, ETH_ALEN)
> with ether_addr_copy, did you use a tool to verify both
> arguments are __aligned(2) or did you do the verification
> visually?

Hello Joe,

I only replaced ETH_ALEN/memcpy .
AFAICS ETH_ALEN is defined 6 ...

Fabian

