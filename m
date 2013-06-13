Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3FMIeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:34:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37702 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab3FMIeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:34:18 -0400
Date: Thu, 13 Jun 2013 01:34:17 -0700 (PDT)
Message-Id: <20130613.013417.1870836967244200694.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: paul.gortmaker@windriver.com, markos.chandras@gmail.com,
        markos.chandras@imgtec.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/3com: Drop EISA dependency from
 VORTEX
From: David Miller <davem@davemloft.net>
In-Reply-To: <51B78C82.7020709@cogentembedded.com>
References: <CAG2jQ8hACp_iGEXR7rXKR3sydK4O=y0paeh1FFgH2UisxWVxVA@mail.gmail.com>
	<51B78594.5050903@windriver.com>
	<51B78C82.7020709@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Wed, 12 Jun 2013 00:45:54 +0400

>    We have the user of 3Com EISA cards on this list and I've fixed EISA
> specific bug in this driver not long ago.

Then I obviously must reject this patch.
