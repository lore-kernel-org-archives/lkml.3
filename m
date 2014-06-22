Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFVSDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:03:18 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52145 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaFVSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:03:17 -0400
Message-ID: <53A71A63.2070207@gmail.com>
Date: Sun, 22 Jun 2014 14:03:15 -0400
From: Jerry Stralko <gerb.stralko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Creating sysfs class for all my misc devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running into a road block trying to create a sysfs class for all my
misc devices I've created.  I currently have a few (3-5) misc devices
that I want to group together in a class.


I've registered my misc devices, but I'm unsure how to associate them
with my new class I created.  I want all my misc devices to be
associated with /sys/class/logger class.


I've created the class via:

        logger_class = class_create(THIS_MODULE, "logger");
        ret = PTR_ERR(logger_class);
        if (IS_ERR(logger_class))
                goto out;

But after the call to misc_register i'm not sure how to proceed.   Is
this even possible or I'm I totally off on this.  Or can a device only
be registered to at most one class and since its a misc device its
already associated with the misc class?

I've searched the linux source tree and haven't found anything.

Any help or pointers on this would be greatly appreciated.

Thanks,
 






