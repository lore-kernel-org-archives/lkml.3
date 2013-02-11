Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3BKQ0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:26:45 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43835 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3BKQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:26:43 -0500
Message-ID: <51191BBE.9080904@suse.cz>
Date: Mon, 11 Feb 2013 17:26:38 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: tmac@hp.com, linuxram@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [stable request] fix stack overflow in __reserve_region_with_split
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think this one should go to stable:
commit 4965f5667f36a95b41cda6638875bc992bd7d18b
Author: T Makphaibulchoke <tmac@hp.com>
Date:   Thu Oct 4 17:16:55 2012 -0700

    kernel/resource.c: fix stack overflow in __reserve_region_with_split()

To all up to 3.7 (exclusive).

thanks,
-- 
js
suse labs
