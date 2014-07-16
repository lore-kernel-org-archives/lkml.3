Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaGPBIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:08:46 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40118 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaGPBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <1405422615.14773.1.camel@joe-AO725>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-28-git-send-email-lftan@altera.com>
	<1405422615.14773.1.camel@joe-AO725>
Date: Wed, 16 Jul 2014 09:08:42 +0800
X-Google-Sender-Auth: CSAhGOMzHlP6UjRjlF7lBr6omNY
Message-ID: <CAFiDJ5-5kVt+m8_+-LkGKnU2vsQbbqGoHuKSpfx6aAgZbC3=-Q@mail.gmail.com>
Subject: Re: [PATCH v2 27/29] MAINTAINERS: Add nios2 maintainer
From: Ley Foon Tan <lftan@altera.com>
To: Joe Perches <joe@perches.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 7:10 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-07-15 at 16:45 +0800, Ley Foon Tan wrote:
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>
> trivia:
>
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -6350,6 +6350,13 @@ S:     Maintained
> []
>> +NIOS2 ARCHITECTURE
>> +M:   Ley Foon Tan <lftan@altera.com>
>> +L:   nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
>> +T:   git://git.rocketboards.org/linux-socfpga.git
>
> this should be:
> T:      git git://git.rocketboards.org/linux-socfpga.git
>
Okay, will fix this.
