Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbbAUUT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:19:26 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61107 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbAUUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:19:18 -0500
Date: Wed, 21 Jan 2015 15:19:17 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Message-ID: <1741852285.168343.1421871557328.JavaMail.root@mail>
In-Reply-To: <20150121182803.GC7386@vmdeb7>
Subject: Re: [PATCH v2 2/3] asus-laptop: use DEVICE_ATTR_* macros
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

> > Use DEVICE_ATTR_{RO,WO,RW} macros to simplify attributes
> > declarations.
>
> It does a lot more than that, including a lot of seemingly
> superfluous reformatting of function declarations and renaming.

What do you mean? DEVICE_ATTR_RW(foo) requires foo_show() and foo_store()
functions, not show_foo() and store_foo().

Thanks,
-v
