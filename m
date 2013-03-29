Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3C2Qry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:47:54 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:59469 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3C2Qrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:47:53 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AopTAHjFVVFV5qjOPGdsb2JhbABDgzq/JAQBgQkXAwEBAQE4NYIfAQEEATocIwULCAMhJQ8FJQoaiCEKCL95BBWNdYEdB4JfYQOWaoYRg2OKJDs
X-IronPort-AV: E=Sophos;i="4.87,374,1363129200"; 
   d="scan'208";a="522847599"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 29 Mar 2013 17:48:41 +0100
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver
Message-ID: <20130329164841.GA2230@polaris.bitmath.org>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> The following patches are a large series of updates in functionality to the
> atmel_mxt_ts touch driver. They apply cleanly to input/next.

I guess this is no longer true.

> These changes address some of the same issues that appear in the patchsets
> submitted by Daniel Kurtz and Peter Meerwald. However, they go much further in
> adding support for new objects, improving performance, and increasing
> reliability. They have been regularly regression tested against old and new
> chips which use the same protocol.
> 
> We also provide a set of user-space utilities as open source which are 
> available from github and work well with this driver:
>   https://github.com/atmel-maxtouch/obp-utils
> 
> Most of my focus in working on these changes has been to support Atmel's
> customers, who tend not to be using the mainline kernel. Unfortunately this 
> has generated somewhat of a backlog in getting these improvements into
> mainline. My current focus is to get these improvements upstream and I have
> time allocated to make any alterations as necessary. Since the scope of this
> patchset is so large any upstream delta tends to cause a big rebasing effort.
> I would suggest that I merge any useful improvements from the other patchsets
> to make a combined patchset.

Are you planning to submit a version for 3.9? If you do, please
consider sending a smaller set.

Thanks,
Henrik
