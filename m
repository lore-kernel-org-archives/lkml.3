Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3FLF1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:27:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50046 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3FLF1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:27:09 -0400
Date: Tue, 11 Jun 2013 22:27:06 -0700 (PDT)
Message-Id: <20130611.222706.1492583255605214982.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130606190929.GB18827@tuxdriver.com>
References: <20130606190929.GB18827@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 6 Jun 2013 15:09:30 -0400

> Johannes Berg (2):
>       mac80211: constify ieee802_11_parse_elems() argument

Such cleanups are absolutely, positively, not appropriate at this
time.

Sorry.

I still can't pull this.
