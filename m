Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaCOCvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:51:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaCOCvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:51:48 -0400
Date: Fri, 14 Mar 2014 22:51:47 -0400 (EDT)
Message-Id: <20140314.225147.855002342224224013.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-03-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140314182024.GA20339@tuxdriver.com>
References: <20140314182024.GA20339@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Mar 2014 19:51:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 14 Mar 2014 14:20:26 -0400

> Please pull these last(?) few wireless bits intended for the 3.14
> stream.  Each is here to address a problem found with a patch already
> merged...
> 
> Dave Jones gives us a memory leak fix, for an error path in brcmfmac.
> 
> Felix Fietkau moves a small delay to make it actually reachable.
> 
> Helmut Schaa fixes an ath9k sequence numbering problem for non-data
> frames.
> 
> Stanislaw Gruszka reverts an earlier fix that was found to cause
> random connection drops on RT5390 PCI adapters
> 
> Please let me know if there are problems!  I'll be back from watching
> the Veronica Mars movie by about 9pm... :-)

:-)

Pulled, thanks John.
