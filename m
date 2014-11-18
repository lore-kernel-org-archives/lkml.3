Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaKRTVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:21:15 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:54183 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaKRTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:21:13 -0500
Date: Tue, 18 Nov 2014 19:21:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: linux-next: build warning after merge of the arm tree
Message-ID: <20141118192103.GF4042@n2100.arm.linux.org.uk>
References: <20141118192507.39f68bb7@canb.auug.org.au>
 <546B9696.4030703@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B9696.4030703@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:57:26AM -0800, Stephen Boyd wrote:
> Urgh, I thought I fixed that but I guess I only took care of not
> assigning it unless we actually need it. Well we can do the #ifdef
> thing, or move to IS_ENABLED. Here's both options.

I'd prefer the first as it increases compiler coverage.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
