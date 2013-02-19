Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3BSST4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:19:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34460 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3BSSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:19:54 -0500
Date: Tue, 19 Feb 2013 13:19:53 -0500 (EST)
Message-Id: <20130219.131953.1403463983805165846.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qca.qualcomm.com, nic-devel@qca.qualcomm.com,
        jwboyer@redhat.com
Subject: Re: [PATCH] atl1c: restore buffer state
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361294589-7316-1-git-send-email-xiong@qca.qualcomm.com>
References: <1361294589-7316-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 10:19:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Wed, 20 Feb 2013 01:23:09 +0800

> in the previous commit : f1f220ea1dda078, the BUSY state of buffer is wrongly
> deleted. this patch just restore it.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>

Applied.
