Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3IVUhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:37:50 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752332Ab3IVUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:37:49 -0400
Message-ID: <523F551A.20101@nod.at>
Date: Sun, 22 Sep 2013 22:37:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Markus Elfring <Markus.Elfring@web.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Would an "information module" be useful?
References: <l1n80j$ofi$1@ger.gmane.org> <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com> <523F4A55.3090106@web.de> <523F4C2A.3050207@nod.at> <523F5361.8040906@web.de>
In-Reply-To: <523F5361.8040906@web.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.09.2013 22:30, schrieb Markus Elfring:
>> You can do all parsing in user space too.
> 
> Is it questionable when a custom prefix of a boot command-line parameter can not
> be mapped to a kernel module?

No.
In the systemd case we have to ensure that we never ever merge a module named "systemd".
It's that easy. :)

>> drivers/misc/ is a nice place do dump such things. :-)
> 
> Is an information sink module (with corresponding data type checks) still an
> "ordinary" driver?

We have all kinds of strange modules/drivers. Usually you don't have to think whether your
module is a "ordinary" driver or not...
See drivers/misc/dummy-irq.c.

Thanks,
//richard

