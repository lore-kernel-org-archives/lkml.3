Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbaGISYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:24:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52498 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaGISYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:24:30 -0400
MIME-Version: 1.0
In-Reply-To: <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 9 Jul 2014 14:24:29 -0400
Message-ID: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
From: Steven Toth <stoth@kernellabs.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org,
        Linux-Media <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Instead of custom approach let's use recently added seq_hex_dump() helper.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

ack

Reviewed-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
