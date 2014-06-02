Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaFBSKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:10:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaFBSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:10:52 -0400
Date: Mon, 02 Jun 2014 11:10:50 -0700 (PDT)
Message-Id: <20140602.111050.54996809312556969.davem@davemloft.net>
To: vfalico@redhat.com
Cc: jiri@resnulli.us, mprivozn@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed as signed integer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140602150150.GF6295@redhat.com>
References: <06d53256e3bf2d0deedb16249082200500da3ee6.1401718809.git.mprivozn@redhat.com>
	<20140602143557.GA2925@minipsycho.orion>
	<20140602150150.GF6295@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 11:10:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Veaceslav Falico <vfalico@redhat.com>
Date: Mon, 2 Jun 2014 17:01:50 +0200

> I wonder, though, if we should document it or just output "Unknown"
> instead of -1.

All of this discussion means that we can't change the format string
without potentially breaking something out there interpreting the -1
value, however it gets output now.

I think we just have to leave things as-is and document them in the
sysfs ABI docs.

I'm not applying this patch.
