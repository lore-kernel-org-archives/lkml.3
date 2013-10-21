Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3JUWr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:47:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44327 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3JUWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:47:26 -0400
Date: Mon, 21 Oct 2013 18:47:24 -0400 (EDT)
Message-Id: <20131021.184724.1305218665434733685.davem@davemloft.net>
To: chas@cmf.nrl.navy.mil
Cc: michael.opdenacker@free-electrons.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: firestream: remove duplicate define
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131021075335.5c9e4490@thirdoffive.cmf.nrl.navy.mil>
References: <1382343161-3243-1-git-send-email-michael.opdenacker@free-electrons.com>
	<20131021075335.5c9e4490@thirdoffive.cmf.nrl.navy.mil>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:47:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
Date: Mon, 21 Oct 2013 07:53:35 -0400

> Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
> 
> On Mon, 21 Oct 2013 10:12:41 +0200
> Michael Opdenacker <michael.opdenacker@free-electrons.com> wrote:
> 
>> This patch removes a duplicate define in drivers/atm/firestream.h
>> 
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
