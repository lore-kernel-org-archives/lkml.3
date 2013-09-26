Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3IZUJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:09:18 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:51544 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IZUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:09:14 -0400
Date: Thu, 26 Sep 2013 16:09:12 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Message-ID: <1414767040.1054326.1380226152008.JavaMail.root@mail>
In-Reply-To: <169123028.921974.1377290733515.JavaMail.root@mail>
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC29 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> Wolfram wrote:
> 
> > > IMHO it makes sense. Why wouldn't we want all platform_data in
> > > include/linux/platform_data/?
> > 
> > For the same reason we don't want all driver source files in one
> > directory? It's a mess.
> 
> Well, that's different. Not all drivers expose platform data, but
> many subsystems have drivers with platform data. A common include
> directory for the *_platform_data structure definitions makes sense.

Also IMO having such header file in include/linux/i2c/ for a driver
declared in drivers/misc/eeprom/ is not very consistent.
So this is the purpose of this include directory. What do you think?

Best,
Vivien
