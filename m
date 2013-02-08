Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946943Ab3BHTXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:23:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946800Ab3BHTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:23:11 -0500
Date: Fri, 08 Feb 2013 14:23:09 -0500 (EST)
Message-Id: <20130208.142309.482339537637350318.davem@davemloft.net>
To: David.Laight@ACULAB.COM
Cc: bhutchings@solarflare.com, freddy@asix.com.tw, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B713F@saturn3.aculab.com>
References: <1360244360-2700-1-git-send-email-freddy@asix.com.tw>
	<1360267375.3605.32.camel@bwh-desktop.uk.solarflarecom.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B713F@saturn3.aculab.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Laight" <David.Laight@ACULAB.COM>
Date: Fri, 8 Feb 2013 10:23:08 -0000

> It is much better to define constants for the bit values and
> explicitly mask them as required.

Yes, __be32/__le32 along with bit define macros is the only reasonable
way to do this kind of stuff.
