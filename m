Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3CGAaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:30:23 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33671 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757607Ab3CGAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:30:20 -0500
X-Sasl-enc: MwUfBTodgVSixzLD6BIe4thuREhEtBnWq4BWGybM7JOL 1362616219
Date: Wed, 6 Mar 2013 21:30:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, ibm-acpi-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: x230: unhandled HKEY event 0x6050
Message-ID: <20130307003016.GA21655@khazad-dum.debian.net>
References: <20130304213804.GE22274@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304213804.GE22274@pd.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Mar 2013, Borislav Petkov wrote:
> I get this in dmesg with 3.9-rc1:
> 
> [   12.951434] thinkpad_acpi: unhandled HKEY event 0x6050
> [   12.951438] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
> [   13.516752] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
> 
> when pressing Fn+F8/F9, i.e. the display backlight keys. I'm loading
> thinkpad_acpi with brightness_enable=1 and booting the kernel with
> "acpi_backlight=vendor" so that the backlight intensity gets controlled
> by thinkpad_acpi. But the last maybe shouldn't complain about it, no?

It shouldn't even work right on a x230, that box should be doing standard
ACPI backlight control...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
