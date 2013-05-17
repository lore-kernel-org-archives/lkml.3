Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3EQUXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:23:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42907 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3EQUXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:23:14 -0400
Date: Fri, 17 May 2013 13:23:13 -0700 (PDT)
Message-Id: <20130517.132313.933656167661213099.davem@davemloft.net>
To: emilio@elopez.com.ar
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: ethernet: sun: initialize variables directly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
References: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 17 May 2013 13:23:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>
Date: Fri, 17 May 2013 12:07:45 -0300

> Clean up the code a bit to initialize the variables directly when
> defining them.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>

Poorly styled, should be:

	u16 hash_table[4] = { 0 };
