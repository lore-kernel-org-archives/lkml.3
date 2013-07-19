Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab3GSHCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:02:32 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63748 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3GSHCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:02:30 -0400
Message-ID: <51E8E482.30505@suse.cz>
Date: Fri, 19 Jul 2013 09:02:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: brcm80211-dev-list@broadcom.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: brcm80211: machine freezing hard with rfkill on
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

our users report [1] that their machines freeze hard when they have
rfkill turned on and try to run wpa_supplicant or enable network
otherwise. This is with BCM43225 over PCI chip.

Any ideas what that could be or how to fix this?

[1] https://bugzilla.novell.com/show_bug.cgi?id=787649

thanks,
-- 
js
suse labs
