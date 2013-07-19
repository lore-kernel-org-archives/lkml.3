Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676Ab3GSCHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:07:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43102 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933633Ab3GSCHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:07:31 -0400
Message-ID: <1374199649.1949.143.camel@joe-AO722>
Subject: docproc.c:
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>, Johannes Berg <johannes@sipsolutions.net>
Cc: mm-commits@vger.kernel.org, fengguang.wu@intel.com,
        linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jul 2013 19:07:29 -0700
In-Reply-To: <51e89d4a.EzMm4kY3e/JyyINM%akpm@linux-foundation.org>
References: <51e89d4a.EzMm4kY3e/JyyINM%akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 18:58 -0700, akpm@linux-foundation.org wrote:
> > docproc: kernel/printk.c: No such file or directory
> So rename the file.
[]
>  Documentation/DocBook/device-drivers.tmpl |    2 +-
[]
> @@ -84,7 +84,7 @@ X!Iinclude/linux/kobject.h
[]
> -!Ekernel/printk.c
> +!Ekernel/printk/printk.c

Hey Rob/Johannes.

I renamed kernel/printk.c to a separate directory and
got warned about docproc.c not finding this file anymore.

These entries seem very arbitrary.
(Also, I've never seen, nor cared about, them before)

Any way to autogenerate this .tmpl file?


