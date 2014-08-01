Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaHARN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:13:27 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47917 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaHARN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:13:26 -0400
MIME-Version: 1.0
Date: Fri, 1 Aug 2014 22:43:23 +0530
Message-ID: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
Subject: [Question: Drivers/base/core.c] Why dev->init_name = NULL in
 device_add function ?
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Greg Kroah-Hartman and Linux Community,
Greetings of the day !! :)

I am Aniroop Mathur working on Linux Kernel for last two years.
I am stuck at one point and could not find the solution over internet.
I posted on linuxquestions.org too.
So I need your help and suggestion for it.

Can you please help in answering my query as below:

=====================================================
In function device_add of /drivers/base/core.c file, it is mentioned:
/*
* for statically allocated devices, which should all be converted
* some day, we need to initialize the name. We prevent reading back
* the name, and force the use of dev_name()
*/
if (dev->init_name) {
dev_set_name(dev, "%s", dev->init_name);
dev->init_name = NULL;
}


Except forcing the use of dev_name to read device name,
Is there any other reason to make init_name as NULL ?
And if it is not made NULL, is there any problem or side-effect ?

=======================================================

Link at linuxquestions.org:
http://www.linuxquestions.org/questions/linux-kernel-70/why-dev-init_name-%3D-null-in-device_add-function-4175504749/


Thanks a lot in advance !

Best Regards,
Aniroop Mathur
