Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaDPTK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:10:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47455 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaDPTKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:10:24 -0400
Date: Wed, 16 Apr 2014 15:10:22 -0400 (EDT)
Message-Id: <20140416.151022.765986603363610723.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, chealy@imsco-us.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] net: mdio-gpio enhancements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397614602-29694-1-git-send-email-linux@roeck-us.net>
References: <1397614602-29694-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Apr 2014 12:10:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 15 Apr 2014 19:16:39 -0700

> The following series of patches adds support for active-low gpio pins
> as well as for systems with separate MDI and MDO pins to the mdio-gpio
> driver.

Series applied, thanks.
