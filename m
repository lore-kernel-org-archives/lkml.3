Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaJNVE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:04:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaJNVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:04:25 -0400
Date: Tue, 14 Oct 2014 17:04:22 -0400 (EDT)
Message-Id: <20141014.170422.659068926985449384.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: mark.d.rustad@intel.com, linux-kernel@vger.kernel.org,
        johannes.berg@intel.com, netdev@vger.kernel.org
Subject: Re: [net] genl_magic: Resolve logical-op warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413293318-9070-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1413293318-9070-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 14:04:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 14 Oct 2014 06:28:38 -0700

> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Resolve "logical 'and' applied to non-boolean constant" warnings"
> that appear in W=2 builds by adding !! to a bit test.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied, thanks Jeff.
