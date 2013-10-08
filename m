Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3JHFAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:00:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42220 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3JHFAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:00:37 -0400
Date: Tue, 08 Oct 2013 01:00:36 -0400 (EDT)
Message-Id: <20131008.010036.748831303031980348.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/8] ide: convert bus code to use dev_groups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381195662-28009-2-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
	<1381195662-28009-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 07 Oct 2013 22:00:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon,  7 Oct 2013 18:27:35 -0700

> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the ide bus code to use the
> correct field.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: <linux-ide@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> David, I can take this through my driver-core tree if you don't want to
> take it through yours, just let me know what works best for you.

Yep, please take it, that works for me:

Acked-by: David S. Miller <davem@davemloft.net>
