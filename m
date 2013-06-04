Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3FDUSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:18:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58116 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3FDUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:18:14 -0400
Date: Tue, 04 Jun 2013 13:18:13 -0700 (PDT)
Message-Id: <20130604.131813.134898245916084893.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130603184817.GD2727@tuxdriver.com>
References: <20130603184817.GD2727@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 3 Jun 2013 14:48:17 -0400

> Please let me know if there are problems!

Sorry, the broadcom brcmfmac changes need to go.

Some of those commits are cleanups, and some of them have the worst
commit log messages ever, the last one for example:

0017-brcmsmac-fix-regression-observed-in-3.10-rc1.patch

has no explanation whatsoever of what the actual problem or regression
is, what aspect of the logic in that function is causing the problem,
and no explanation why making this function always return 'false' is a
reasonable fix.

That entire series is of very low quality, and even if it was in good
shape, at least half the changes are not appropriate at all this late
in the -rc series.
