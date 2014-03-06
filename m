Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaCFTbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:31:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60135 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaCFTbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:31:32 -0500
Date: Thu, 06 Mar 2014 14:31:30 -0500 (EST)
Message-Id: <20140306.143130.1210832721936446995.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 3/6] Drivers: net: hyperv: Enable offloads on the host
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394104390-23477-3-git-send-email-kys@microsoft.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-3-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 11:31:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu,  6 Mar 2014 03:13:07 -0800

> +		/*
> +		 * can't put_rndis_request, since we may still receive a
> +		 * send-completion.
> +		 */

Please fix the formatting of this comment.

> +	/*
> +	 * Turn on the offloads; the host supports all of the relevant
> +	 * offloads.
> +	 */

Likewise.

> +	/*
> +	 * A value of zero means "no change"; now turn on what we
> +	 * want.
> +	 */

Likewise.
