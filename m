Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaJHAbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:31:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49658 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbaJHAbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:31:04 -0400
Date: Tue, 07 Oct 2014 20:30:59 -0400 (EDT)
Message-Id: <20141007.203059.188333030684868215.davem@davemloft.net>
To: paul@paul-moore.com
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] netlabel: kernel-doc warning fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <18856194.K9PbrNbEaI@sifl>
References: <1412713892-5537-1-git-send-email-fabf@skynet.be>
	<18856194.K9PbrNbEaI@sifl>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 17:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Tue, 07 Oct 2014 18:13:34 -0400

> On Tuesday, October 07, 2014 10:31:32 PM Fabian Frederick wrote:
>> no secid argument in netlbl_cfg_unlbl_static_del
>> 
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> Thanks.  Likely a copy/paste error from netlbl_cfg_unlbl_static_add().
> 
> Acked-by: Paul Moore <paul@paul-moore.com>

Applied, thanks everyone.
