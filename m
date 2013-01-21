Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3AUROK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:14:10 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47482 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3AUROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:14:07 -0500
Date: Mon, 21 Jan 2013 12:14:01 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1329559360.389477.1358788441066.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <alpine.LNX.2.00.1301211714520.8266@pobox.suse.cz>
Subject: Re: [PATCH] HID: add ThingM blink(1) USB LED support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> hid-blink sounds too generic to me, taking into account that this is
> not
> 'generic HID blinking' framework, but rather a specific device driver
> for
> a particular device.
> 
> So something like hid-thingm-blink sounds more reasonable to me.

Ok, I'll name the file hid-thingm-blink1.c instead.
Should I keep the Kconfig macro CONFIG_BLINK1 or CONFIG_THINGM_BLINK1
sounds better?

> Linux Kernel is being shipped under GPL v2, without "or any later"
> clause
> added. So I am afraid I can't merge the code with this license.

No problem, I'll change the clause.

Thanks,
Vivien
