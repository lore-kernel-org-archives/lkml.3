Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162058Ab3DEQfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:35:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60684 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162021Ab3DEQfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:35:21 -0400
Message-ID: <1365179719.2075.1.camel@joe-AO722>
Subject: Re: [PATCH] nfc: Remove useless Makefile line
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 09:35:19 -0700
In-Reply-To: <1365179481.1830.69.camel@x61.thuisdomein>
References: <1365179481.1830.69.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 18:31 +0200, Paul Bolle wrote:
> There's no Kconfig symbol NFC_DEBUG. Besides, there doesn't seem to be
> any nfc code that uses a DEBUG macro. This line can safely be removed.
[]
> diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
[]
> -ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG

pr_debug/dev_dbg/nfc_dev_dbg logging messages
depend on this.


