Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3EQU7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:59:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3EQU7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:59:24 -0400
Date: Fri, 17 May 2013 13:59:20 -0700 (PDT)
Message-Id: <20130517.135920.1195448152850771943.davem@davemloft.net>
To: emilio@elopez.com.ar
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] net: ethernet: sun: initialize variables
 directly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368823376-13104-1-git-send-email-emilio@elopez.com.ar>
References: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
	<1368823376-13104-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 17 May 2013 13:59:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>
Date: Fri, 17 May 2013 17:42:53 -0300

> Clean up the code a bit to initialize the variables directly when
> defining them.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>

Applied.
