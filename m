Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3BRR0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:26:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3BRR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:26:54 -0500
Date: Mon, 18 Feb 2013 12:26:53 -0500 (EST)
Message-Id: <20130218.122653.2052167397005650003.davem@davemloft.net>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH]net: ehea module param description fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <511f24e7.iqc1+9PTu6xF8JTF%dyoung@redhat.com>
References: <511f24e7.iqc1+9PTu6xF8JTF%dyoung@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dyoung@redhat.com
Date: Sat, 16 Feb 2013 14:19:19 +0800

> In ehea.h the minimal entries is 2^7 - 1:
> #define EHEA_MIN_ENTRIES_QP  127
> 
> Thus change the module param description accordinglly
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Applied.
