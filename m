Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaE3AQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:16:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38778 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753789AbaE3AQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:16:23 -0400
Date: Fri, 30 May 2014 01:13:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Jianguo Wu <wujianguo@huawei.com>, Wang Nan <wangnan0@huawei.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qiuxishi <qiuxishi@huawei.com>
Subject: Re: [PATCH v3] ARM: mm: support big-endian page tables
Message-ID: <20140530001354.GN3693@n2100.arm.linux.org.uk>
References: <534F9F79.9050503@huawei.com> <87ob00wau2.fsf@approximate.cambridge.arm.com> <20140423132033.GE5649@arm.com> <53587C48.8080103@huawei.com> <5386A799.7040403@huawei.com> <20140529075837.GA29812@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529075837.GA29812@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:58:38AM +0100, Will Deacon wrote:
> On Thu, May 29, 2014 at 04:20:57AM +0100, Jianguo Wu wrote:
> > Hi Russell,
> > Could you please merge this to mainline? Thanks!
> 
> Give him a chance, it's not the merge window yet ;) I can see it queued in
> his for-next branch.

It's not like it's something that has ever worked in the past - so
it's really a new feature rather than a bug fix, even through we've
been growing BE support in other areas.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
