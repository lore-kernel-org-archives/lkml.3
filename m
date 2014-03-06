Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCFTby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:31:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60148 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaCFTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:31:53 -0500
Date: Thu, 06 Mar 2014 14:31:50 -0500 (EST)
Message-Id: <20140306.143150.1028304529548626294.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 4/6] Drivers: net: hyperv: Enable receive side IP
 checksum offload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394104390-23477-4-git-send-email-kys@microsoft.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-4-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 11:31:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu,  6 Mar 2014 03:13:08 -0800

> +		/*
> +		 * We only look at the IP checksum here.
> +		 * Should we be dropping the packet if checksum
> +		 * failed? How do we deal with other checksums - TCP/UDP?
> +		 */

Please fix the formatting of this cmment.

