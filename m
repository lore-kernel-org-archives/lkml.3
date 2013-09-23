Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3IWCip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:38:45 -0400
Received: from plane.gmane.org ([80.91.229.3]:46867 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3IWCio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:38:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Would an "information module" be useful?
Date: Mon, 23 Sep 2013 04:38:30 +0200
Message-ID: <523FA9A6.40600@web.de>
References: <l1n80j$ofi$1@ger.gmane.org> <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com> <523F4A55.3090106@web.de> <523F4C2A.3050207@nod.at> <523F5361.8040906@web.de> <523F551A.20101@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f048038158.adsl.alicedsl.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
In-Reply-To: <523F551A.20101@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the systemd case we have to ensure that we never ever merge a module named "systemd".

Interesting ...


> We have all kinds of strange modules/drivers. Usually you don't have to think
> whether your module is a "ordinary" driver or not...

Would it become useful to move "drivers" which do not manage hardware to a
separate directory?
Should such source files belong to a different software category (or "class")?

Regards,
Markus

