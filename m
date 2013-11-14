Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3KNW0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:26:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3KNW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:26:40 -0500
Date: Thu, 14 Nov 2013 17:26:37 -0500 (EST)
Message-Id: <20131114.172637.288809112911669556.davem@davemloft.net>
To: geyslan@gmail.com
Cc: arvid.brodin@xdin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/hsr: Fix possible leak in 'hsr_get_node_status()'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384456378-29970-1-git-send-email-geyslan@gmail.com>
References: <1384456378-29970-1-git-send-email-geyslan@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 14 Nov 2013 14:26:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Geyslan G. Bem" <geyslan@gmail.com>
Date: Thu, 14 Nov 2013 16:12:54 -0300

> If 'hsr_get_node_data()' returns error, going directly to 'fail' label
> doesn't free the memory pointed by 'skb_out'.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>

Looks good, applied, thanks!
