Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3CFEyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:54:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60811 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3CFEyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:54:03 -0500
Date: Tue, 05 Mar 2013 23:54:01 -0500 (EST)
Message-Id: <20130305.235401.548455441771005291.davem@davemloft.net>
To: jasowang@redhat.com
Cc: maxk@qti.qualcomm.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com,
        hkchu@google.com
Subject: Re: [PATCH] net: docs: document multiqueue tuntap API
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362539123-24863-1-git-send-email-jasowang@redhat.com>
References: <1362539123-24863-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 20:54:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed,  6 Mar 2013 11:05:23 +0800

> Signed-off-by: Jason Wang <jasowang@redhat.com>

Please fix these warnings emitted by GIT:

Applying: net: docs: document multiqueue tuntap API
/home/davem/src/GIT/net/.git/rebase-apply/patch:31: space before tab in indent.
  	struct ifreq ifr;
/home/davem/src/GIT/net/.git/rebase-apply/patch:32: space before tab in indent.
  	int fd, err, i;
/home/davem/src/GIT/net/.git/rebase-apply/patch:34: space before tab in indent.
  	if (!dev)
/home/davem/src/GIT/net/.git/rebase-apply/patch:35: space before tab in indent.
  		return -1;
/home/davem/src/GIT/net/.git/rebase-apply/patch:37: space before tab in indent.
  	memset(&ifr, 0, sizeof(ifr));
warning: squelched 29 whitespace errors
warning: 34 lines add whitespace errors.
