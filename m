Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3CaPp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 11:45:56 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:33619 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3CaPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 11:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130331041115.GA13304@roeck-us.net>
References: <1364695148-5605-1-git-send-email-tonychung00@gmail.com>
	<1364695148-5605-2-git-send-email-tonychung00@gmail.com>
	<20130331041115.GA13304@roeck-us.net>
Date: Sun, 31 Mar 2013 08:45:54 -0700
Message-ID: <CAHyaeP2YgVFaE77xayFuSGwHWc9yZZ9KZjLveXD+QvipKxW=qQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] watchdog: fix w83627hf_wdt reboot due to timeout expired
From: Tony Chung <tonychung00@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this?

-       t &= ~0xC0;               /* disable keyboard & mouse turning off
-                                   watchdog */
+       t &= ~0xE0;               /* clear timeout occurred and disable keyboard
+                                    & mouse turning off watchdog */




Thanks,
@Tony
