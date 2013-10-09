Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3JIOlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:41:53 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34938 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3JIOlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:41:51 -0400
Message-ID: <1381329703.4971.18.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] ipv6: Unbreak build
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Oct 2013 07:41:43 -0700
In-Reply-To: <1381328067-1593-2-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
	 <1381328067-1593-2-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 16:14 +0200, Thierry Reding wrote:
> IPv6 specific fields in struct sock_common are accessed in various
> places even if IPv6 support is disabled. Fix this by including the
> fields unconditionally.

Well no. There is a reason we keep CONFIG_IPV6 at all.

The right fix is under review :
http://patchwork.ozlabs.org/patch/281784/

Thanks


