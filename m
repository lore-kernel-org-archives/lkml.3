Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab3E2BKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:10:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33091 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:10:14 -0400
Date: Tue, 28 May 2013 18:10:13 -0700 (PDT)
Message-Id: <20130528.181013.949144580400693356.davem@davemloft.net>
To: f.wiessner@smart-weblications.de
Cc: matt@ecsorl.com, gregkh@linuxfoundation.org, andy@greyhouse.net,
        fubar@us.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com,
        liquidhorse@gmail.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
From: David Miller <davem@davemloft.net>
In-Reply-To: <51A55381.9080807@smart-weblications.de>
References: <519DEE6E.7060700@smart-weblications.de>
	<519E0F97.1050102@ecsorl.com>
	<51A55381.9080807@smart-weblications.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Smart Weblications GmbH - Florian Wiessner <f.wiessner@smart-weblications.de>
Date: Wed, 29 May 2013 03:01:53 +0200

> Am 23.05.2013 14:46, schrieb Matthew O'Connor:
>> On 05/23/2013 06:24 AM, Smart Weblications GmbH - Florian Wiessner wrote:
>>> node02:/ocfs2/usr/src/linux-3.4.46# cat drivers/net/bonding/bond_alb.c.rej
>> My most sincere apologies - one more time, from a different mail server
>> that hopefully won't go around changing my attachments.  If this doesn't
>> work I guess sendmail will be the next alternative.
>> 
> 
> 3.4.47 got released without that included :-/?!
> 
> https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.4.47

Things take time, I haven't worked on a networking -stable submission
in a while, I'll get to it by the end of the wake.

Be patient.
