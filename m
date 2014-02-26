Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaBZUsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:48:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBZUsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:48:03 -0500
Date: Wed, 26 Feb 2014 15:48:01 -0500 (EST)
Message-Id: <20140226.154801.1466276966991949680.davem@davemloft.net>
To: bjorn@mork.no
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock
 Gigabit LAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <87zjle6pif.fsf@nemi.mork.no>
References: <1393404871-2248-1-git-send-email-freddy@asix.com.tw>
	<87zjle6pif.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 12:48:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Wed, 26 Feb 2014 13:13:12 +0100

> freddy@asix.com.tw writes:
> 
>> From: Freddy Xin <freddy@asix.com.tw>
>>
>> Add VID:DID for Lenovo OneLinkDock Gigabit LAN
> 
> This is the same patch Keith Packard sent, but with a slighly different
> description.  I take that as another proof that we should not attempt to
> describe devices in these drivers.  Describe the driver instead.

Are you saying that this patch needs to be implemented differently?
