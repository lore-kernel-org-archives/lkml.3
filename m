Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3GAHDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GAHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:03:22 -0400
Message-ID: <1372662173.2974.17.camel@cr0>
Subject: Re: [RFC Patch net-next 2/5] net: introduce generic inet_pton()
From: Cong Wang <amwang@redhat.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 15:02:53 +0800
In-Reply-To: <1372347124.2436.3.camel@bwh-desktop.uk.level5networks.com>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-3-git-send-email-amwang@redhat.com>
	 <1372347124.2436.3.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 16:32 +0100, Ben Hutchings wrote:
> The return values for this are awful.  I think the return value should
> be 0 for success or -EINVAL on error.
> 
> The caller can then check addr->sa.sa_family if they want to know the
> address family immediately. 

Indeed, I will fix it.

Thanks!

