Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3AUNXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:23:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48229 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3AUNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:23:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olivier Doucet <webmaster@ajeux.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: Performance issue since 3.2.6
Date: Mon, 21 Jan 2013 14:29:33 +0100
Message-ID: <2462618.rQxKXSuBtr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAPPqfY0-dEnm5JnTo=6ybTjv+A-1uz=ZRR4zcU5sPs+jBxbhLQ@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <1396763.8sOcKf8eSO@vostro.rjw.lan> <CAPPqfY0-dEnm5JnTo=6ybTjv+A-1uz=ZRR4zcU5sPs+jBxbhLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 02:18:29 PM Olivier Doucet wrote:
> Hello,
> 
> 2013/1/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > It looks like the value returned by pm_qos_request() with CONFIG_PM unset
> > for PM_QOS_CPU_DMA_LATENCY is not the right one.
> 
> FYI, I benchmarked a new version with :
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> 
> but the performance loss is still present.

In that case it is not quite likely that the commit you bisected to
really introduced the problem, because it doesn't change things for
CONFIG_PM=y.

Does reverting that commit still help?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
