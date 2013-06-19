Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab3FSWs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:48:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45698 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab3FSWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:48:56 -0400
Date: Wed, 19 Jun 2013 15:48:53 -0700 (PDT)
Message-Id: <20130619.154853.2105911759808459657.davem@davemloft.net>
To: steve.moorby@ntlworld.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific
 ethernet device
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C21253.2070308@ntlworld.com>
References: <1371655613-31969-1-git-send-email-steve.moorby@ntlworld.com>
	<20130619.121802.2112053686285060471.davem@davemloft.net>
	<51C21253.2070308@ntlworld.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Moorby <steve.moorby@ntlworld.com>
Date: Wed, 19 Jun 2013 21:19:31 +0100

> I will be using an Ubuntu 10.04 kernel with the 'eth_dev' module
> parameter patch.  I appreciate a better solution needs to be designed
> but it is not one I can contribute to.  I still advocate the patch as
> an improvement on the current non functional situation.

We don't put poorly designed changes into the tree simply because
a properly implemented version doesn't exist yet.
