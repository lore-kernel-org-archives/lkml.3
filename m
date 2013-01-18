Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab3ARGVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:21:25 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:46500 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3ARGVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:21:24 -0500
MIME-Version: 1.0
Date: Fri, 18 Jan 2013 11:51:23 +0530
Message-ID: <CAGZFCEFX8RzTN1DkGpxkeFqNG-+QWVaus7-B__nQEi75DpY2CA@mail.gmail.com>
Subject: softirq: No local_irq_save() in local_bh_enable()
From: ratheesh kannoth <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Below was quoted from
http://linux-kernel.2935.n7.nabble.com/PATCH-softirq-Use-local-irq-save-in-local-bh-enable-td383387.html

"Anyway, a commit 0f476b6d91a1395bda6464e653ce66ea9bea7167 "softirq:
remove irqs_disabled warning from local_bh_enable" can break things
after changing from local_irq_save() to local_irq_disable(). Before
this commit there was only a warning, now a lockup is possible, so
it could be treated as a regression. This patch reverts the change
in irqs. "


But i could not see the usage  of local_irq_save() in newer kernels (
3.7.3 ). Could you please tell me , why we did not take this patch ?

-Ratheesh
