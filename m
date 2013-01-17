Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3AQTvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:51:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3AQTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:50:59 -0500
Date: Thu, 17 Jan 2013 14:50:56 -0500 (EST)
Message-Id: <20130117.145056.60689530330513006.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-01-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130117173239.GA2098@tuxdriver.com>
References: <20130117173239.GA2098@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 17 Jan 2013 12:32:40 -0500

> This batch of fixes is intended for 3.8...
> 
> Included is a Bluetooth pull.  Gustavo says:
> 
> "A few fixes for 3.8. Five of them are just new devices ids addition.
> Apart from the that there is fix to a kernel memory leak to userspace from
> Anderson Lizardo, two interoperability fixes from Jaganath Kanakkassery and
> Szymon Janc. And a crash fix by me."
> 
> Along with that, Amitkumar Karwar brings a pair of mwifiex fixes for
> problems related to handling of band information within the driver.
> These problems can lead to association failures.
> 
> Sujith Manoharan fixes a memory leak in the ath9k_htc code (originally
> reported by Larry Finger).
> 
> The big hero this round is Felix Fietkau.  Felix gives us seven
> ath9k fixes, including a fix for a race condition, the removal of a
> double-free, and a fix for a deadlock, among others.
> 
> These have all been in linux-next for at least a couple of days,
> with no complaints so far.  Please let me know if there are problems!

Pulled, thanks John.
