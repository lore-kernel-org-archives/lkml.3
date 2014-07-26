Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaGZSMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:12:38 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8569 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGZSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:12:36 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-ac-53d3ef9257f4
Date: Sat, 26 Jul 2014 15:12:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org,
        Linux-Media <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
Message-id: <20140726151226.44cbb027.m.chehab@samsung.com>
In-reply-to: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/hYN1J7y8HG6w4oGLR2zSdyeL+p9uM
	Ft2vZCxeHtjAbnH/3k8miz17T7JYXN41h82iZ8NWVosJC5uZLV5++8xqseu/ncXhax1sFvf/
	HGG0OP/3OKsDn8fBR4fYPD58jPPYdkDVY/Gel0wec4/1MnrMOxno8XmTnMemJ2+ZAjiiuGxS
	UnMyy1KL9O0SuDLmf/ApeMxccbhnMmMDYz9zFyMHh4SAicSDldpdjJxAppjEhXvr2boYuTiE
	BJYwSuy/PJMJwmlkkvjU9ZgJpIpFQFXi2IMfbCA2m4CRxKvGFlYQW0RATWLRy1XsIA3MAo+Z
	JY4sOssCkhAWsJOY++Y6WAOvgJXE5t2/wGxOgWCJ5R2/mCE2PGKUmHn4FjvEHc4SP2dOYoRo
	EJT4Mfke2CBmAS2JzduaWCFseYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFC0tTi4oTkrPNdIr
	TswtLs1L10vOz93ECImg4h2MLzZYHWIU4GBU4uHdcfVSsBBrYllxZe4hRgkOZiUR3idTLwcL
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYFQuF3t09EBI/IO5fqrV//W49a6L3tn5fIrIY8cVk2cF
	bV/1YIqu8K0Z/DpBad6/3wmVXrice6/o00LLaUeUZQ48bfzHLfQ/6knHNLuWl4b2PqUzblho
	btaoZL25wXqhR1zbxa0hbHqxn2zUy+VMZ9wLdnpzovjFHD0O3bqiW/w+HBffuv9MmqXEUpyR
	aKjFXFScCABZ9qcsfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 9 Jul 2014 14:24:29 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Instead of custom approach let's use recently added seq_hex_dump() helper.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> ack
> 
> Reviewed-by: Steven Toth <stoth@kernellabs.com>
> 
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Regards,
Mauro
