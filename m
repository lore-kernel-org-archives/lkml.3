Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbaDIEMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:12:09 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36720 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaDIEMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:12:08 -0400
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 23:12:06 -0500
Message-ID: <CAKZq+reJuhKE6L67RfZL7Zyd6W=cU-ehK3faBKmj3stVg5ukdA@mail.gmail.com>
Subject: USB: OMAP: questions on patch "Implement runtime idling and remote
 wakeup for OMAP EHCI controller"
From: Chao Xu <caesarxuchao@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rogerq@ti.com, stern@rowland.harvard.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two questions about this patch series. Any help is appreciated.
1. in the cover letter(https://lkml.org/lkml/2013/7/10/355), it states
"the series implements suspend/resume for the OMAP EHCI host
controller during runtime idle". I don't understand when is the EHCI
host controller "runtime idle"? Does "runtime idle" refers to when all
attached USB devices are suspended? or does it refer to whenever there
is no tx/rx ongoing in the EHCI host controller?

2. I think the purpose of the patch is to allow the USB power domain
(namely, L3INIT power domain) to enter low power state. So assuming
the power domain is now in RETENTION state, will the EHCI host be able
to detect remote wakeup in this case? i.e. will the ULPI DATA0, DATA1
and DATA3 reflect the Linestate and Interrupt when the L3INIT power
domain is in RETENTION? Put it in another way, when the power domain
in is a low power state defined in OMAP spec, is the USB host and PHY
in  "low power mode" defined in USB spec?

Thank you!




Regards,
Chao Xu
