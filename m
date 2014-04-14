Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaDNEez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 00:34:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49861 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDNEey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 00:34:54 -0400
Date: Mon, 14 Apr 2014 00:34:49 -0400 (EDT)
Message-Id: <20140414.003449.294037863611224523.davem@davemloft.net>
To: sgalgano@adjacentlink.com
Cc: mst@redhat.com, jasowang@redhat.com, xemul@parallels.com,
        wuzhy@linux.vnet.ibm.com, therbert@google.com, yamato@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian.Adamson@nrl.navy.mil,
        jgiovatto@adjacentlink.com
Subject: Re: [PATCH v2] tuntap: add flow control to support back pressure
From: David Miller <davem@davemloft.net>
In-Reply-To: <534B61C2.1080700@adjacentlink.com>
References: <534B3A33.9090401@adjacentlink.com>
	<20140413.214004.1087903132047842986.davem@davemloft.net>
	<534B61C2.1080700@adjacentlink.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Apr 2014 21:34:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not post new versions of a patch as a reply to an existing
discussion.

Instead, post a fresh new email for the patch.
