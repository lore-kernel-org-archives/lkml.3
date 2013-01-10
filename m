Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3AJTRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:17:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59241 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AJTRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:17:37 -0500
X-Originating-IP: 108.223.40.66
Date: Thu, 10 Jan 2013 11:18:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: checkpatch.pl error: Use of uninitialized value $max (line 3407,3410)
Message-ID: <20130110191807.GA15621@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I get the following error when running checkpatch.pl:

scripts/checkpatch.pl -f drivers/hwmon/da9055-hwmon.c
Use of uninitialized value $max in string eq at scripts/checkpatch.pl line 3407.
Use of uninitialized value $max in pattern match (m//) at scripts/checkpatch.pl line 3410.
total: 0 errors, 0 warnings, 336 lines checked

drivers/hwmon/da9055-hwmon.c has no obvious style problems and is ready for
submission.

The checkpatch code creating the error was introduced with commit 4a273195
(checkpatch: check usleep_range() arguments).

Is this a but in checkpatch, or is something wrong in my environment ?

Thanks,
Guenter
