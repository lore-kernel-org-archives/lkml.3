Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaCFVH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:07:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33350 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCFVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:07:57 -0500
Date: Thu, 06 Mar 2014 16:07:55 -0500 (EST)
Message-Id: <20140306.160755.1956883639088872825.davem@davemloft.net>
To: bhelgaas@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: fix compiler array bounds warning on settings[]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140305003544.23016.55079.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140305003544.23016.55079.stgit@bhelgaas-glaptop.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 13:07:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 04 Mar 2014 17:35:44 -0700

> With -Werror=array-bounds, gcc v4.7.x warns that in phy_find_valid(), the
> settings[] "array subscript is above array bounds", I think because idx is
> a signed integer and if the caller supplied idx < 0, we pass the guard but
> still reference out of bounds.
> 
> Fix this by making idx unsigned here and elsewhere.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied, thanks.
