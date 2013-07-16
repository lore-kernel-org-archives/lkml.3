Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab3GPTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:15:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab3GPTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:15:27 -0400
Date: Tue, 16 Jul 2013 12:15:26 -0700 (PDT)
Message-Id: <20130716.121526.349910660553329882.davem@davemloft.net>
To: dragos.foianu@gmail.com
Cc: ben@decadent.org.uk, pshelar@nicira.com, mschmidt@redhat.com,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: fixed trailing statements in ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373722980-19704-1-git-send-email-dragos.foianu@gmail.com>
References: <1373722980-19704-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 12:15:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Foianu <dragos.foianu@gmail.com>
Date: Sat, 13 Jul 2013 14:43:00 +0100

> Applied fixes suggested by checkpatch.pl.
> 
> Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>

Applied, but only so that life is easier for the next person who
makes changes to this file and wants to validate things with
checkpatch.
