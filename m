Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaFFSfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:35:34 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:44682 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFFSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:35:33 -0400
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Scott Alfter <scott@alfter.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "greg@kroah.com" <greg@kroah.com>
In-Reply-To: <37853c31eb688a3745310acf905ca9fa.squirrel@webmail.alfter.us>
References: <1853313.sEkU5HsBDk@kaylee> <64681401965067@web25m.yandex.ru> <37853c31eb688a3745310acf905ca9fa.squirrel@webmail.alfter.us>
Subject: Re: new driver: w1_ds2406
MIME-Version: 1.0
Message-Id: <786161402079729@web30h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 06 Jun 2014 22:35:29 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

Greg, please pull this patch into the tree

06.06.2014, 21:47, "Scott Alfter" <scott@alfter.us>:
> On Thu, June 5, 2014 10:44, Evgeniy Polyakov wrote:
>> š04.06.2014, 08:25, "Scott Alfter" <scott@alfter.us>:
>>> šI have a project for which I needed support for the DS2406 addressable
>>> šswitch, so I started with an existing driver and modified it as needed.
>>> šIt allows the switch outputs to be controlled over the bus, which is
>>> šwhat I needed from it.
>> šDriver seems good, although debug prints like 'mutex is locked' are better
>> što be dropped.
>
> Those were in the DS2413 driver, which I used as a base for my changes.
> I've taken them out. šAlso, I fixed a typo I made in the description in a
> Kconfig file.
>> šPlease send this patch to linux-kernel@ and add me and greg@kroah.com to
>> šcopy, and patch will be pulled upstream.
>> šFeel free to add my acked/reviewed-by tags.
>
> Signed-off-by: Scott Alfter <scott@alfter.us>
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> Reviewed-by: Evgeniy Polyakov <zbr@ioremap.net>
