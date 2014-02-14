Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaBNSgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:36:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35244 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBNSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:36:20 -0500
Date: Fri, 14 Feb 2014 13:36:17 -0500 (EST)
Message-Id: <20140214.133617.1389101802638585879.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: stefan.sorensen@spectralink.com, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] dp83640: Get pin and master/slave configuration
 from DT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140214090601.GA3906@netboy>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
	<20140213.173957.2126489785330496380.davem@davemloft.net>
	<20140214090601.GA3906@netboy>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2014 10:36:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Fri, 14 Feb 2014 10:06:01 +0100

> People want to be able to configure the auxiliary functions on the
> pins of their PTP devices. My preference for supporting this is:
> 
> 1. additional ioctl on the PTP character device
> 2. ethtool ioctl
> 3. DT and/or ACPI
> 
> The first option seems best because that is how you activate the
> auxiliary functions. I am working on something in this direction.

Probably since PTP already uses ioctls, and that is the activation
point, yes that seems the best approach.
