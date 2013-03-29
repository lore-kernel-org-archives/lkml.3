Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3C2DNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 23:13:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59777 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3C2DNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 23:13:24 -0400
X-Spam-Score: -100.8
Message-ID: <5154EAB9.2080108@asianux.com>
Date: Fri, 29 Mar 2013 09:13:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: edumazet@google.com, dborkman@redhat.com, wad@chromium.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux: printk is needed in filter.h when CONFIG_BPF_JIT
 is defined
References: <5153DC24.4010104@asianux.com> <20130328.143158.157689302620030740.davem@davemloft.net>
In-Reply-To: <20130328.143158.157689302620030740.davem@davemloft.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê03ÔÂ29ÈÕ 02:31, David Miller wrote:
> Please post networking patches to netdev@vger.kernel.org, thanks.

  ok, thanks, it is my fault.
    originally, I get the mail addresses from ./scripts/get_maintainer.pl.
    it is a useful tool to help members to find mail addresses.
    I should fully use it, but should not depend on it.

  next time, I should think of the mail addresses, after get them from the tool.

  thanks.

-- 
Chen Gang

Asianux Corporation
