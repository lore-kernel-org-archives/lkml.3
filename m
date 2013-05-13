Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3EMUHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:07:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3EMUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:07:50 -0400
Date: Mon, 13 May 2013 13:07:49 -0700 (PDT)
Message-Id: <20130513.130749.1053380556995548595.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: mason@myri.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] myri_sbus: remove firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368475385.1350.70.camel@x61.thuisdomein>
References: <1365171782.1830.67.camel@x61.thuisdomein>
	<20130405.125530.727706283199340601.davem@davemloft.net>
	<1368475385.1350.70.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Mon, 13 May 2013 22:03:05 +0200

> Dave,
> 
> On Fri, 2013-04-05 at 12:55 -0400, David Miller wrote:
>> From: Paul Bolle <pebolle@tiscali.nl>
>> > Support for MyriCOM Gigabit Ethernet cards was removed in v3.1. Remove
>> > the firmware too.
>> > 
>> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> 
>> Acked-by: David S. Miller <davem@davemloft.net>
> 
> I don't think this patch has been queued for mainline anywhere. Would
> you mind queuing this in a tree you maintain?

I don't maintain the firmware tree, therefore I cannot do that.
