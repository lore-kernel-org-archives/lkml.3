Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3CVOHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:07:46 -0400
Received: from www17.your-server.de ([213.133.104.17]:41473 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3CVOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:07:45 -0400
Message-ID: <1363961254.11400.8.camel@localhost.localdomain>
Subject: Re: CONFIG_EARLY_PRINTK
From: Thomas Meyer <thomas@m3y3r.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Date: Fri, 22 Mar 2013 15:07:34 +0100
In-Reply-To: <5144AE20.7030202@infradead.org>
References: <1363194921.1218.14.camel@localhost.localdomain>
	  <5140D9DF.4010506@infradead.org>
	 <1363446518.12329.5.camel@localhost.localdomain>
	 <5144AE20.7030202@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 16.03.2013, 10:38 -0700 schrieb Randy Dunlap:
> On 03/16/13 08:08, Thomas Meyer wrote:
> > Am Mittwoch, den 13.03.2013, 12:56 -0700 schrieb Randy Dunlap:
> > Yes,
> > 
> > so why not do this? As the text to EARLY_PRINTK explains?
> 
> Yes, the default should match the help text.
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Please resend your patch with Signed-off-by: line.
> 
> Thanks.

Align EARLY_PRINTK default value with help text value.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..852d51c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -32,7 +32,6 @@ config X86_VERBOSE_BOOTUP
 
 config EARLY_PRINTK
        bool "Early printk" if EXPERT
-       default y
        ---help---
          Write kernel log output directly into the VGA buffer or to a serial
          port.


