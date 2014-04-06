Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaDFUKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:10:42 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62841 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbaDFUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:10:40 -0400
Message-ID: <1396815038.4886.11.camel@x220>
Subject: Re: Kconfig circular dependency question
From: Paul Bolle <pebolle@tiscali.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 22:10:38 +0200
In-Reply-To: <5341AFC7.1070001@lwfinger.net>
References: <5341AFC7.1070001@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 20:10:39.0006 (UTC) FILETIME=[4769B3E0:01CF51D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 14:49 -0500, Larry Finger wrote:
> A kernel build is reporting the following:
> 
> net/rfkill/Kconfig:4:error: recursive dependency detected!
> net/rfkill/Kconfig:4:   symbol RFKILL is selected by R8723AU
> drivers/staging/rtl8723au/Kconfig:1:    symbol R8723AU depends on USB
> drivers/usb/Kconfig:41: symbol USB is selected by MOUSE_APPLETOUCH
> drivers/input/mouse/Kconfig:162:        symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:        symbol INPUT is selected by ACPI_CMPC
> drivers/platform/x86/Kconfig:635:       symbol ACPI_CMPC depends on RFKILL

I must be having a slow day, but how should this be parsed to see the
recursive dependency?

> What is the recommended way to avoid this circularity? Of course, R8723AU could 
> select USB rather than depending on it, but that does not seem quite right.

Thanks,


Paul Bolle

