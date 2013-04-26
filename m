Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3DZR7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:59:39 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59428 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3DZR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:59:38 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: linux-next: Tree for Apr 26 (nfc)
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <517ABA92.304@infradead.org>
Date: Fri, 26 Apr 2013 10:59:40 -0700
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, linux-nfc@ml01.01.org
Content-Transfer-Encoding: 7bit
Message-Id: <C716D09B-A010-4024-B115-9BDB834DE905@holtmann.org>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <517ABA92.304@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

>> Hi all,
>> 
>> Changes since 20130424:
>> 
> 
> 
> on i386:
> 
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a36d): undefined reference to `rfkill_unregister'
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a378): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a493): undefined reference to `rfkill_alloc'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4a4): undefined reference to `rfkill_register'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4b3): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_dev_up':
> (.text+0x6a8e8): undefined reference to `rfkill_blocked'
> 
> 
> when CONFIG_RFKILL=m but NFC is builtin.
> 
> Full randconfig file is attached.

it is missing the depends RFKILL || !RFKILL here. I send a patch for it.

Regards

Marcel

