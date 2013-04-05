Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162095Ab3DEQjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:39:22 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:61993 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162036Ab3DEQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:39:21 -0400
Message-ID: <1365179958.1830.72.camel@x61.thuisdomein>
Subject: Re: [PATCH] nfc: Remove useless Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 18:39:18 +0200
In-Reply-To: <1365179719.2075.1.camel@joe-AO722>
References: <1365179481.1830.69.camel@x61.thuisdomein>
	 <1365179719.2075.1.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2013 16:39:18.0754 (UTC) FILETIME=[1E344C20:01CE321C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 09:35 -0700, Joe Perches wrote:
> On Fri, 2013-04-05 at 18:31 +0200, Paul Bolle wrote:
> > -ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
> 
> pr_debug/dev_dbg/nfc_dev_dbg logging messages
> depend on this.

Thanks. But then a NFC_DEBUG symbol needs to be added, because now the
DEBUG macro will never be set, won't it?


Paul Bolle

