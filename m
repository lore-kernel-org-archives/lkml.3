Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaHAH6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:58:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60339 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751334AbaHAH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:58:49 -0400
Date: Fri, 1 Aug 2014 08:58:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com
Subject: Re: [PATCH] ARM: l2x0: fix build warning without CONFIG_OF
Message-ID: <20140801075843.GO30282@n2100.arm.linux.org.uk>
References: <1406860920-23520-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406860920-23520-1-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:42:00AM +0800, Kefeng Wang wrote:
> Commit cf9ea8f13(ARM: l2c: remove obsolete l2x0 ops for non-OF init)
> remove some obsolete l2x0 ops, the rest of ops: l2x0_cache_sync,
> l2x0_cache_sync, l2x0_disable only use under OF enable, so move them
> into OF part, or "defined but not used" warning occurs.

I'm not interested; I've stated previously that I want these warnings
to stay until such time that the code which uses them is fixed up to
use the new methods.

The warnings act as an advertisment that it needs fixing properly.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
