Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaB0U7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:59:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaB0U7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:59:47 -0500
Date: Thu, 27 Feb 2014 15:59:35 -0500 (EST)
Message-Id: <20140227.155935.2071416701209004953.davem@redhat.com>
To: mcgrof@do-not-panic.com
Cc: ben@decadent.org.uk, netdev@vger.kernel.org, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] net: start kdoc'ifying net_device
From: David Miller <davem@redhat.com>
In-Reply-To: <1393377313-28695-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393377313-28695-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 25 Feb 2014 17:15:11 -0800

> While working on extending some functionality I felt restricted
> with the amount of documentation I can add. Part of this is that
> the existing style on the header files don't let me be verbose.
> This starts addressing that by using kdoc for the net_device
> flags, and as Ben noted, the priv_flags can be moved out from
> UAPI.

Series applied, thanks Luis.
