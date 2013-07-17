Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3GQJSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:18:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44429 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3GQJSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:18:30 -0400
Message-ID: <1374052705.3146.86.camel@hornet>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
From: Pawel Moll <pawel.moll@arm.com>
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Date: Wed, 17 Jul 2013 10:18:25 +0100
In-Reply-To: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 17 Jul 2013 09:18:26.0125 (UTC) FILETIME=[97C1AFD0:01CE82CE]
X-MC-Unique: 113071710182808901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 17:05 +0100, Lorenzo Pieralisi wrote:
> /drivers/mfd is probably not the right place for this code as it stands (but
> probably will be when the entire driver, with DVFS and config interface, is
> complete).

Not that it really matters now, but my vexpress-sysreg rework will -
most likely - leave only skeleton in the MFD (registering mfd_cells) and
other stuff is going to be spread all around. Then I'm planning to move
the remaining of the vexpress-specific initialization to
drivers/platform/arm/vexpress.c, so maybe sticking vexpress-spc.c to
this (non-existing yet) directory would be the right thing to do?

Other than that:

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Paweł


