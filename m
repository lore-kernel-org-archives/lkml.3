Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab3CTBKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:10:35 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49076 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3CTBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130318171140.4f5fddbc@redhat.com>
References: <1361945213-4280-1-git-send-email-andrew.smirnov@gmail.com>
	<1361945213-4280-2-git-send-email-andrew.smirnov@gmail.com>
	<20130318171140.4f5fddbc@redhat.com>
Date: Tue, 19 Mar 2013 18:10:32 -0700
Message-ID: <CAHQ1cqHviVN1cwTYvG7AuF4Fqj86LWvwxnGKT0hUVfearoOwCw@mail.gmail.com>
Subject: Re: [PATCH v7 1/9] mfd: Add commands abstraction layer for SI476X MFD
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sameo@linux.intel.com, sam@ravnborg.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 1:11 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Tue, 26 Feb 2013 22:06:45 -0800
> Andrey Smirnov <andrew.smirnov@gmail.com> escreveu:
>
>> This patch adds all the functions used for exchanging commands with
>> the chip.
>
> Please run checkpatch.pl over those patches. There are a number of compliants
> on those patches:
>

OK, will do shortly and send updated patch-set.

> WARNING: line over 80 characters
> #328: FILE: drivers/mfd/si476x-cmd.c:298:
> +       err = si476x_core_i2c_xfer(core, SI476X_I2C_SEND, (char *) data, argn + 1);
>
> WARNING: line over 80 characters
> #378: FILE: drivers/mfd/si476x-cmd.c:348:
> +               dev_err(&core->client->dev, "[CMD 0x%02x] Chip set error flag\n", command);
>

I do have a question about this particular warning though. Weird
indentation that I had to use in order to calm checkpatch.pl about
that issue has been a topic of discussion and complaints once
already(see https://lkml.org/lkml/2012/9/21/67) To my understanding
the consensus was as far as it improves readability > 80 character
lines are OK. What would you like me do with those extra long lines
ignore all/fix all/use discretion and fix some?
