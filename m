Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaJHAbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:31:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49662 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaJHAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:31:10 -0400
Date: Tue, 07 Oct 2014 20:27:25 -0400 (EDT)
Message-Id: <20141007.202725.1687093471259249604.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, inaky.perez-gonzalez@intel.com,
        linux-wimax@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] wimax: convert printk to pr_foo()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412712724-4100-1-git-send-email-fabf@skynet.be>
References: <1412712724-4100-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 17:31:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  7 Oct 2014 22:12:03 +0200

> Use current logging functions and add module name prefix.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.
