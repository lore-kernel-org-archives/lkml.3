Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3EKXNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 19:13:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60203 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3EKXNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 19:13:14 -0400
Date: Sat, 11 May 2013 16:13:12 -0700 (PDT)
Message-Id: <20130511.161312.2021294984526564526.davem@davemloft.net>
To: yefremov.denis@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH 11/21] ipv4: ip_output: remove inline marking of
 EXPORT_SYMBOL functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368091192-10245-6-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	<1368091192-10245-6-git-send-email-yefremov.denis@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Efremov <yefremov.denis@gmail.com>
Date: Thu,  9 May 2013 13:19:42 +0400

> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Applied, thanks.
