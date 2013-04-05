Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162087Ab3DEQqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:46:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59658 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162023Ab3DEQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:46:54 -0400
Message-ID: <1365180413.2075.5.camel@joe-AO722>
Subject: Re: [PATCH] nfc: Remove useless Makefile line
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 09:46:53 -0700
In-Reply-To: <1365179958.1830.72.camel@x61.thuisdomein>
References: <1365179481.1830.69.camel@x61.thuisdomein>
	 <1365179719.2075.1.camel@joe-AO722>
	 <1365179958.1830.72.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 18:39 +0200, Paul Bolle wrote:
> On Fri, 2013-04-05 at 09:35 -0700, Joe Perches wrote:
> > On Fri, 2013-04-05 at 18:31 +0200, Paul Bolle wrote:
> > > -ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
> > 
> > pr_debug/dev_dbg/nfc_dev_dbg logging messages
> > depend on this.
> 
> Thanks. But then a NFC_DEBUG symbol needs to be added, because now the
> DEBUG macro will never be set, won't it?

Probably right.

I think all the nfc_dev_<level> uses are unsightly too.
Almost all the nfc_dev_dbg uses are functdion enter/leave
logging and should be done via the function tracer.

I'll submit some patches for that.


