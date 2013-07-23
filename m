Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3GWPvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:51:12 -0400
Received: from fep20.mx.upcmail.net ([62.179.121.40]:61000 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:51:10 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51EEA665.2050209@odi.ch>
Date: Tue, 23 Jul 2013 17:51:01 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_X86_PKG_TEMP_THERMAL causes #GP fault on Core i7-740QM
 breaking boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think the bug is already fixed in this commit:

f3ed0a17f0292300b3caca32d823ecd32554a667

Thermal: x86 package temp thermal crash



Thanks,

Ortwin
