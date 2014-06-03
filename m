Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaFCADC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:03:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaFCAC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:02:59 -0400
Date: Mon, 02 Jun 2014 17:02:58 -0700 (PDT)
Message-Id: <20140602.170258.144328105696750793.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: jdmason@kudzu.us, kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] vxge: Remove useless return variables
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401542051-3174-10-git-send-email-peter.senna@gmail.com>
References: <1401542051-3174-10-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 17:02:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Sat, 31 May 2014 10:14:10 -0300

> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
...
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.
