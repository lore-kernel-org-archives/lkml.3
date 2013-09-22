Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3IVUak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:30:40 -0400
Received: from plane.gmane.org ([80.91.229.3]:50746 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3IVUaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:30:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Would an "information module" be useful?
Date: Sun, 22 Sep 2013 22:30:25 +0200
Message-ID: <523F5361.8040906@web.de>
References: <l1n80j$ofi$1@ger.gmane.org> <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com> <523F4A55.3090106@web.de> <523F4C2A.3050207@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f048038158.adsl.alicedsl.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
In-Reply-To: <523F4C2A.3050207@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can do all parsing in user space too.

Is it questionable when a custom prefix of a boot command-line parameter can not
be mapped to a kernel module?


> But I'm sure it will not get merged.

Thanks for your feedback.


> All you need is a dummy module with a few module_param()s.

My ideas went in such a direction.


> drivers/misc/ is a nice place do dump such things. :-)

Is an information sink module (with corresponding data type checks) still an
"ordinary" driver?

Regards,
Markus

