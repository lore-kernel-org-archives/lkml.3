Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3HWTkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:40:21 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:63320 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3HWTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:40:20 -0400
Date: Fri, 23 Aug 2013 15:40:18 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Wolfram Sang <wsa@the-dreams.de>, kernel@savoirfairelinux.com,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <276016030.909379.1377286818459.JavaMail.root@mail>
In-Reply-To: <1377285996.620418788@f48.i.mail.ru>
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alexander wrote:
> Can this file be additionally renamed to misc-at24.h to reflect
> belongs to a particular subsystem?

I'm not sure about that. Having the subsystem name at the beginning of
the file doesn't seem to be a convention for all subsystems. For
instance, this is true for gpio, spi or leds, but not for hwmon.
Actually, I would stick with the corresponding subsystem naming, here:
at24.c -> at24.h.

Regards,
Vivien
