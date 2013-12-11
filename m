Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LKDLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:11:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53949 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LKDLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:11:47 -0500
Date: Tue, 10 Dec 2013 22:11:44 -0500 (EST)
Message-Id: <20131210.221144.1520834419856689475.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com, mst@redhat.com, vyasevich@gmail.com
Subject: Re: [PATCH net V2 1/2] tun: unbreak truncated packet signalling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386654586-18151-1-git-send-email-jasowang@redhat.com>
References: <1386654586-18151-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 19:11:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You and Michael are still discussing these changes it seems.

I accidently commited the first version of these patches, but then
immediately reverted that after I saw the followups.

Let me know when you have something both of you are happy with.

Thanks.
