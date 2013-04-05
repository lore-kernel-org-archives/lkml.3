Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162184Ab3DEQzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:55:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162039Ab3DEQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:55:35 -0400
Date: Fri, 05 Apr 2013 12:55:30 -0400 (EDT)
Message-Id: <20130405.125530.727706283199340601.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: mason@myri.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] myri_sbus: remove firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365171782.1830.67.camel@x61.thuisdomein>
References: <1365171782.1830.67.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 05 Apr 2013 09:55:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Fri, 05 Apr 2013 16:23:02 +0200

> Support for MyriCOM Gigabit Ethernet cards was removed in v3.1. Remove
> the firmware too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: David S. Miller <davem@davemloft.net>
