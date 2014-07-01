Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbaGAH22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:28:28 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:41730 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbaGAH21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:28:27 -0400
Date: Tue, 1 Jul 2014 11:27:45 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Adam Baker <linux@baker-net.org.uk>
cc: gregkh@linuxfoundation.org, hsommer@eso.org, matwey.kornilov@gmail.com,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org
Subject: Re: [Linux-parport] [PATCH 2/2] parport: parport_pc: Add force_epp
 module option for parport_pc.
In-Reply-To: <53B1E8E5.6080808@baker-net.org.uk>
Message-ID: <alpine.LRH.2.00.1407011021500.17090@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1406301248200.15067@lnfm1.sai.msu.ru> <53B1E8E5.6080808@baker-net.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +#ifdef CONFIG_PARPORT_1284
>> +MODULE_PARM_DESC(force_epp, "Do not disable EPP when it is detected to
>> be broken (default is false)");
>
> I think this needs some more explanation - how about
> "Disable check for broken Intel EPP hardware that gives false positives on 
> 2002 and newer hardware"

I would like to keep force_epp option reusable, then description should be 
hardware-agnostic.

Maybe: "Force EPP enabling when buggy hardware found by the module checks."
