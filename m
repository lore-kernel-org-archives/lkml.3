Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3AUSgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:36:37 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:58911 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3AUSgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:36:35 -0500
Date: Mon, 21 Jan 2013 13:36:29 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <721702502.537216.1358793389745.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <1329559360.389477.1358788441066.JavaMail.root@mail.savoirfairelinux.com>
Subject: Re: [PATCH] HID: add ThingM blink(1) USB LED support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote:
> Should I keep the Kconfig macro CONFIG_BLINK1 or CONFIG_THINGM_BLINK1
> sounds better?

CONFIG_HID_THINGM_BLINK1 is definitely more explicit. Here's a link to the v2:
https://lkml.org/lkml/2013/1/21/435

Thanks,
Vivien
