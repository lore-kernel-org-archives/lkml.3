Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaILVyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:54:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51682 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaILVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:54:44 -0400
Date: Fri, 12 Sep 2014 17:54:40 -0400 (EDT)
Message-Id: <20140912.175440.1013837932148725302.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 1/3] virtio_net: pass well-formed sgs to
 virtqueue_add_*()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410396458-1165-2-git-send-email-rusty@rustcorp.com.au>
References: <1410396458-1165-1-git-send-email-rusty@rustcorp.com.au>
	<1410396458-1165-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 14:54:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do you guys want me to take this series directly into net-next?
