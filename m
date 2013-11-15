Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3KOQJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:09:35 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43410 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3KOQJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:09:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131115155822.GN26614@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
	<CAGG-pUT22xoksid-2GmJsDmVQk8gR8zHvAr=r3Z2E4BLf+1jJA@mail.gmail.com>
	<5286215A.4020009@linux.com>
	<CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
	<20131115155822.GN26614@sirena.org.uk>
Date: Fri, 15 Nov 2013 14:09:19 -0200
Message-ID: <CAGG-pUQ7pykDycLZZ1q1-ShqAN=XdX0DuhdzNtwTS5+C+GLfVQ@mail.gmail.com>
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: levex@linux.com, Caizhiyong <caizhiyong@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/15 Mark Brown <broonie@kernel.org>:
> On Fri, Nov 15, 2013 at 01:52:19PM -0200, Geyslan Gregório Bem wrote:
>
>> +       if (WARN_ONCE(num_regs <= 0, "number of registers [%d] must be
>> major than 0", num_regs))
>> +               return 0;
>
> "must be more than" but yes.

Tks. Sorry for my poor english. :D

-- 
Regards,

Geyslan G. Bem
hackingbits.com
