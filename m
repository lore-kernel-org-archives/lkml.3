Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaAaVay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:30:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39009 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaAaVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:30:53 -0500
Date: Fri, 31 Jan 2014 13:30:51 -0800 (PST)
Message-Id: <20140131.133051.483295479425700960.davem@davemloft.net>
To: agordeev@redhat.com
Cc: linux-kernel@vger.kernel.org, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/34] bnx2: Use pci_enable_msix_range()
From: David Miller <davem@davemloft.net>
In-Reply-To: <434a34e01c353441131204edef36126a95e8928a.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
	<434a34e01c353441131204edef36126a95e8928a.1391172839.git.agordeev@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please submit this patch series when the net-next tree opens back up,
I'm only accepting bug fixes at this time.

Also, please always provide a proper "00/NN" openning posting for a
patch series, that gives background and high level information about
what your patch series is trying to achieve and how it achieves it.

That way people reviewing the patches know what to expect, and why,
and I have exactly one posting to reply to if I apply the whole
series.

Thank you.
