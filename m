Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaE2H7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:59:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38656 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756290AbaE2H7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:59:18 -0400
Date: Thu, 29 May 2014 08:58:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
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
Message-ID: <20140529075837.GA29812@arm.com>
References: <534F9F79.9050503@huawei.com>
 <87ob00wau2.fsf@approximate.cambridge.arm.com>
 <20140423132033.GE5649@arm.com>
 <53587C48.8080103@huawei.com>
 <5386A799.7040403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386A799.7040403@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:20:57AM +0100, Jianguo Wu wrote:
> Hi Russell,
> Could you please merge this to mainline? Thanks!

Give him a chance, it's not the merge window yet ;) I can see it queued in
his for-next branch.

Will
