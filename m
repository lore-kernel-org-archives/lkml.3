Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab3BTRxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:53:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48042 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3BTRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:53:04 -0500
Date: Wed, 20 Feb 2013 12:53:01 -0500 (EST)
Message-Id: <20130220.125301.1295321158433252629.davem@davemloft.net>
To: lee.roberts@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sctp: fix association hangs due to
 reassembly/ordering logic
From: David Miller <davem@davemloft.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310ABA1@G4W3231.americas.hpqcorp.net>
References: <1361374860.3450.1.camel@laptop.lroberts>
	<D64EC45690EF85409BA6C4730E0162244310ABA1@G4W3231.americas.hpqcorp.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 09:53:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your email client has corrupted every one of your patches, splitting up
new lines as well as making other alterations, making them useless for
us.

Please read Documentation/email-clients.txt to learn how to fix this
problem, and only resubmit your patches when you can successfully
email a patch to yourself and cleanly apply the patch you receive
in that email as-is.

Thanks.
