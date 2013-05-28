Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab3E1PeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:34:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48967 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374Ab3E1PeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <51A4A614.7080707@huawei.com>
References: <5192E650.3070303@huawei.com>
	<519C3BD1.6050307@huawei.com>
	<51A4A614.7080707@huawei.com>
Date: Tue, 28 May 2013 18:34:15 +0300
Message-ID: <CAHp75Ve6Y637=aROj9nLN-vPgBkecYJTm=uWQU7veeEaSSq==w@mail.gmail.com>
Subject: Re: [PATCH v2] usb: omap2430: fix memleak in err case
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Li Zefan <lizefan@huawei.com>,
        USB <linux-usb@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No go.

Check the 4b7e450fb5cefb5865c77999a675330206ab3b8a
And update you tree, please.

--
With Best Regards,
Andy Shevchenko
