Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3FLHmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:42:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51193 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3FLHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:42:42 -0400
Date: Wed, 12 Jun 2013 00:42:41 -0700 (PDT)
Message-Id: <20130612.004241.761719664465563112.davem@davemloft.net>
To: sujith@msujith.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20920.8752.339655.254147@gargle.gargle.HOWL>
References: <20130611.222706.1492583255605214982.davem@davemloft.net>
	<20130612.002103.916991474696226731.davem@davemloft.net>
	<20920.8752.339655.254147@gargle.gargle.HOWL>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith Manoharan <sujith@msujith.org>
Date: Wed, 12 Jun 2013 12:54:32 +0530

> David Miller wrote:
>> John, I also don't like the ATK9K Kconfig option name change added in
>> this pull request, this is exactly the kind of thing that drives
>> Linus insane.
>> 
>> Change the default, fine, but changing the name is unnecssary churn
>> and adds a new config prompt that people are going to respond to
>> incorrectly when they type "make oldconfig"
> 
> This was Linus' suggestion: https://patchwork.kernel.org/patch/2676971/
> 
> The RH bugzilla appears to be down at the moment, but more background
> for the bug is here: https://bugzilla.redhat.com/show_bug.cgi?id=927191

Fair enough, I rescind my objection.
