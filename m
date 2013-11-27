Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3K0MVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:21:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53045 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab3K0MVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:21:46 -0500
Date: Wed, 27 Nov 2013 12:20:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131127122053.GG9032@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-3-git-send-email-liuj97@gmail.com>
 <20131030001245.GB25346@mudshark.cambridge.arm.com>
 <527671E9.8040704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527671E9.8040704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang Liu,

On Sun, Nov 03, 2013 at 03:55:21PM +0000, Jiang Liu wrote:
> On 10/30/2013 08:12 AM, Will Deacon wrote:
> > If I try and email you at your Huawei address, I get a bounce from the mail
> > server. Is that expected? If so, it's not very helpful from a commit log
> > perspective if you use that address as the author on your patches.
> > 
> Hi Will,
> 	Sorry for the inconvenience. I have left Huawei recently and
> have had a vacation last two weeks. I will use my gmail account next
> time.

I appreciate that you're probably not being paid to look at this anymore,
but have you had a chance to address the comments I made on version 5 of
this series? As far as I'm concerned, this is almost ready for merging and
I'd love to see it get in for 3.14!

It would be a real shame if this ended up getting dropped...

Cheers,

Will
