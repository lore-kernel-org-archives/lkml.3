Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaCaU0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:26:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCaU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:26:09 -0400
Date: Mon, 31 Mar 2014 16:26:07 -0400 (EDT)
Message-Id: <20140331.162607.153228065356865845.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: chien.yen@oracle.com, rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rds: prevent dereference of a NULL device in
 rds_iw_laddr_check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396139975-5314-1-git-send-email-sasha.levin@oracle.com>
References: <1396139975-5314-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Mar 2014 13:26:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 29 Mar 2014 20:39:35 -0400

> Binding might result in a NULL device which is later dereferenced
> without checking.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied, thanks Sasha.
