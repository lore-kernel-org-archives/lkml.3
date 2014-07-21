Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaGUVcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:32:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36608 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaGUVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:32:32 -0400
Date: Mon, 21 Jul 2014 14:32:25 -0700 (PDT)
Message-Id: <20140721.143225.2040366896972949930.davem@davemloft.net>
To: olaf@aepfle.de
Cc: richard@nod.at, yuezha@microsoft.com, netdev@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, jasowang@redhat.com,
        haiyangz@microsoft.com, kys@microsoft.com, huishao@microsoft.com,
        decui@microsoft.com
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140721091851.GA28171@aepfle.de>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	<53CCD6F2.6020909@nod.at>
	<20140721091851.GA28171@aepfle.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 14:32:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>
Date: Mon, 21 Jul 2014 11:18:51 +0200

> On Mon, Jul 21, Richard Weinberger wrote:
> 
>> My concern is that 10 seconds is maybe not a the right choice.
>> (As we cannot know all implementations)
> 
> Until someone reports an issue with it, 10 is fine. Just like 20 or 666.

Wrong, this is policy and belongs in userspace.
