Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3HVDFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:05:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3HVDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:05:34 -0400
Date: Wed, 21 Aug 2013 20:05:33 -0700 (PDT)
Message-Id: <20130821.200533.2282704635493963288.davem@davemloft.net>
To: vincent.stehle@laposte.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, dingtianhong@huawei.com
Subject: Re: [PATCH linux-next] ipv6: fix missing braces in
 ip6_tnl_add_linklocal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377123597-26515-1-git-send-email-vincent.stehle@laposte.net>
References: <1377123597-26515-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 20:05:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I already reverted the change in question.
