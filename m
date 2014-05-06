Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbaEFDQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:16:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbaEFDQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:16:22 -0400
Date: Tue, 6 May 2014 05:16:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 19/24] net, diet: Make RPS configurable
Message-ID: <20140506031621.GO2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-20-git-send-email-andi@firstfloor.org>
 <20140505.231433.1853863657752503508.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.231433.1853863657752503508.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:14:33PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:26:08 -0700
> 
> > Multiple receive queues are not needed on small systems,
> > so allow disabling them.
> 
> It's only enabled with SMP...

You didn't read the whole description, did you?

-Andi
