Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbbANONa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:13:30 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48113 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbANON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:13:28 -0500
Date: Wed, 14 Jan 2015 09:13:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] kernfs: convert node name allocation to kstrdup_const
Message-ID: <20150114141325.GD3565@htj.dyndns.org>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
 <1421054323-14430-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421054323-14430-3-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:18:40AM +0100, Andrzej Hajda wrote:
> sysfs frequently performs duplication of strings located
> in read-only memory section. Replacing kstrdup by kstrdup_const
> allows to avoid such operations.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
