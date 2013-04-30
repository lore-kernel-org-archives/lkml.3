Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab3D3EMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:12:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39483 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3D3EMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:12:06 -0400
Date: Tue, 30 Apr 2013 00:12:01 -0400 (EDT)
Message-Id: <20130430.001201.1764845606650321215.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2013-04-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130429194550.GC4590@tuxdriver.com>
References: <20130429194550.GC4590@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 21:12:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 29 Apr 2013 15:45:51 -0400

> For the Bluetooth bits, Gustavo says:
> 
> "A few more patches intended for 3.10, the most important one is the support in
> btusb for fw loading for the Intel Bluetooth device. Other than that we have
> only fixes and clean ups."
> 
> For the iwlwifi bits, Johannes says:
> 
> "Here are a few more changes for the 3.10 stream, some bugfixes,
> adjustments to some powersave parameters and a new device ID."
> 
> For the NFC bits, Samuel says:
> 
> "This pull request includes Marcel's Kconfig dependency fix on top of the LLCP
> code move to net/nfc."
> 
> On top of that...Yogesh Ashok Powar provides a few PCI-related mwifiex
> updates, Hauke Mehrtens provides a small ssb feature for spurious
> tone avoidance on a specific chip, and Larry Finger provides a small
> rtlwifi fix related to avoiding false detection of AP loss.

Pulled, thanks John.
