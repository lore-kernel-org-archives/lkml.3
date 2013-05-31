Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3EaMBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:01:23 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59496 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3EaMBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 31 May 2013 14:01:18 +0200
Message-ID: <CACRpkdZnaN=TOB9nZJUS5EPXcCDoMiBvoL47AufDOOcDoH-khg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] gpio-langwell: initialize lock before usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:20 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> Otherwise we will end up with traceback from LOCKDEP:

Andy do you consider this a regression that needs to go into fixes?

I.e. is this used in in-tree code and causing problems with v3.10...

I'm asking because it creates a mess as the rest of the series depend
on it.

It is currently applied for v3.11.

Yours,
Linus Walleij
