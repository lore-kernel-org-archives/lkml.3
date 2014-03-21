Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaCUSWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:22:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaCUSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:22:04 -0400
Date: Fri, 21 Mar 2014 14:22:00 -0400 (EDT)
Message-Id: <20140321.142200.844343833964886553.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        christian.riesch@omicron.at, stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next v3 0/9] ptp: dynamic pin control
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1395350105.git.richardcochran@gmail.com>
References: <cover.1395350105.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Mar 2014 11:22:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Thu, 20 Mar 2014 22:21:51 +0100

> This patch series introduces a way of changing the auxiliary PTP
> Hardware Clock functions (periodic output signals and time stamping
> external signals) at run time. In the past on the netdev list, we have
> discussed other ways to handle this, such as module parameters and
> ethtool. This series implements a new PHC ioctl because that is the
> most natural way. Users already activate the auxiliary functions via
> the ioctls. The sysfs interface has also been expanded so that the pin
> configuration can be programmed using shell scripts.
> 
> The first patch adds the new ioctls. The PHC subsystem does most of
> the work of maintaining the function-to-pin mapping. Drivers will only
> need to allocate and initialize a pin configuration table and also
> provide a new method that validates a particular assignment.
> 
> Patches 5 and 6 just clean up a couple of issues in the phyter driver,
> and the remaining patches actually hook the phyter's pins into the new
> system.
> 
> Comments and questions are most welcome.

Series applied, thanks Richard.
