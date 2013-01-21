Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3AUNSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:18:31 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:50787 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3AUNSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <1396763.8sOcKf8eSO@vostro.rjw.lan>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<2125649.yvtIPMVHz8@vostro.rjw.lan>
	<CAPPqfY0VaTRXKMvfKccZSwvmQP_9jLKse29ZsaP3SeSm+xKvBg@mail.gmail.com>
	<1396763.8sOcKf8eSO@vostro.rjw.lan>
Date: Mon, 21 Jan 2013 14:18:29 +0100
Message-ID: <CAPPqfY0-dEnm5JnTo=6ybTjv+A-1uz=ZRR4zcU5sPs+jBxbhLQ@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/1/18 Rafael J. Wysocki <rjw@sisk.pl>:
> It looks like the value returned by pm_qos_request() with CONFIG_PM unset
> for PM_QOS_CPU_DMA_LATENCY is not the right one.

FYI, I benchmarked a new version with :
CONFIG_PM_RUNTIME=y
CONFIG_PM=y

but the performance loss is still present.

Olivier
