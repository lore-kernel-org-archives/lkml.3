Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab3D2TPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:15:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33342 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab3D2TPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:15:34 -0400
Date: Mon, 29 Apr 2013 15:15:28 -0400 (EDT)
Message-Id: <20130429.151528.2251094691456287740.davem@davemloft.net>
To: linux@prisktech.co.nz
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] Add support for velocity network driver on
 platform devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367221841-14563-1-git-send-email-linux@prisktech.co.nz>
References: <1367221841-14563-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 12:15:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You prepared these patches against a net-next tree which is at least
a week old, I know this because that's when the NETIF_F_* flags for
VLAN offloading changed their names which causes your third patch
to fail to apply.

Do not do this, net-next changes every day and rapidly, don't take
the chance that the driver you're touching is unpopular and thus
hasn't had changes to it recently.  Tree-wide interface changes
happen all the time.
