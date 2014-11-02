Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaKBXZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 18:25:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40397 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaKBXZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 18:25:37 -0500
Date: Sun, 02 Nov 2014 18:25:35 -0500 (EST)
Message-Id: <20141102.182535.323217098195813665.davem@davemloft.net>
To: sgunderson@bigfoot.com
Cc: tgraf@suug.ch, linux-kernel@vger.kernel.org, nikolay@redhat.com
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141102215536.GB29939@sesse.net>
References: <20141021133144.GA8802@casper.infradead.org>
	<20141023233751.GA10504@sesse.net>
	<20141102215536.GB29939@sesse.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Nov 2014 15:25:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Date: Sun, 2 Nov 2014 22:55:36 +0100

> On Fri, Oct 24, 2014 at 01:37:51AM +0200, Steinar H. Gunderson wrote:
>>> I'm currently testing the patch below and will submit with proper
>>> tested by attributions later today.
>> We applied this patch in a reboot today (on top of 3.17.1), and so far,
>> things seem to be going much better.
> 
> I see 3.17.2 is out. Am I right in that this patch didn't make it?

It got queued up for -stable after I submitted networking patches
for 3.17.2, so yes.
