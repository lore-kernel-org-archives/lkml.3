Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3CDLrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:47:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:51458 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab3CDLrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:47:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Mon, 04 Mar 2013 12:54:23 +0100
Message-ID: <12853583.ZUFP9lbocK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130304105841.39ba4afbd1b45cf0b31e4449@canb.auug.org.au>
References: <20130304105841.39ba4afbd1b45cf0b31e4449@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 04, 2013 10:58:41 AM Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/base/power/qos.c: In function '__dev_pm_qos_flags':
> drivers/base/power/qos.c:64:2: error: implicit declaration of function 'IS_ERR_OR_NULL' [-Werror=implicit-function-declaration]
> drivers/base/power/qos.c: In function 'dev_pm_qos_constraints_destroy':
> drivers/base/power/qos.c:248:2: error: implicit declaration of function 'ERR_PTR' [-Werror=implicit-function-declaration]
> drivers/base/power/qos.c:248:17: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/base/power/qos.c: In function 'dev_pm_qos_add_request':
> drivers/base/power/qos.c:294:2: error: implicit declaration of function 'IS_ERR' [-Werror=implicit-function-declaration]
> drivers/base/power/qos.c: At top level:
> drivers/base/power/qos.c:202:13: warning: '__dev_pm_qos_hide_latency_limit' used but never defined [enabled by default]
> drivers/base/power/qos.c:203:13: warning: '__dev_pm_qos_hide_flags' used but never defined [enabled by default]
> 
> Caused by commit 1e3b5df683e2 ("PM / QoS: Remove device PM QoS sysfs
> attributes at the right place").
> 
> I have used the pm tree from next-20130301 for today.

Thanks for the report and sorry for the breakage.  It should be fixed now.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
