Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3I0GdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:33:04 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35339 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3I0GdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:33:03 -0400
MIME-Version: 1.0
Date: Fri, 27 Sep 2013 00:33:01 -0600
Message-ID: <CAL3hBVom_Zzf8Fp6Xb2wGNR0ks=MXAMyyHCVqOGfVqVXb9ET1g@mail.gmail.com>
Subject: Regarding CONFIG_PARAVIRT_TIME_ACCOUNTING
From: Yun Wang <bimingery@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this option is enabled, do we take VM steal time into account when
updating cpu_power?
As a result, there will be less load on vCPUs with smaller cpu_power  ?

Thanks.
