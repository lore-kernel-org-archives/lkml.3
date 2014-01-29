Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaA2J3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:29:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58018 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaA2J3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:29:42 -0500
Message-ID: <52E8CA00.7060303@gmail.com>
Date: Wed, 29 Jan 2014 11:29:36 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        chf.fritz@googlemail.com, nm@ti.com
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com> <52E76EE0.2060006@ti.com> <52E7F451.7040708@gmail.com> <52E8C586.7040907@ti.com>
In-Reply-To: <52E8C586.7040907@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29.01.2014 11:10, Tero Kristo wrote:

>
> It looks like the omap36xx version of the omap96m_alwon_fck is modelled
> improperly in the dts files. I don't have access to omap36xx hardware
> myself, but give a try for the following patch:
>
>

It could be that 36xx omap96m_alwon_fck clock is wrongly modeled, but I 
am testing on 1) 3430es2 (Nokia N900) and 2) legacy boot, so I guess 
that patch won't help much (unless I am missing something and DT is used 
even with legacy boot and 36xx clocks are used on 3430es2)

Thanks,
Ivo
