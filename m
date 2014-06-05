Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaFEBfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:35:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46154 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbaFEBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:35:44 -0400
X-IronPort-AV: E=Sophos;i="4.98,977,1392134400"; 
   d="scan'208";a="31474562"
Message-ID: <538FCA83.2050708@cn.fujitsu.com>
Date: Thu, 5 Jun 2014 09:40:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: use "pool->cpu < 0" to stand for an unbound
 pool
References: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com> <538FC5F8.1020605@cn.fujitsu.com> <20140605011729.GA14370@mtj.dyndns.org>
In-Reply-To: <20140605011729.GA14370@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 09:17 AM, Tejun Heo wrote:
> On Thu, Jun 05, 2014 at 09:20:56AM +0800, Lai Jiangshan wrote:
>> And would these patches be possible for 3.16?
> 
> It's a bit too late.  I'd like to wait for the next merge window.

OK,

> AFAICS, there's nothing critical, right?

They are normal cleanups.

Thanks,

