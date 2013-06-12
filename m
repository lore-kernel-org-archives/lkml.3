Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3FLFQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:16:40 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38027 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3FLFQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:16:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTxyODK+VFwK2csbxSs7LzAe2EqMXemxFRYF+A26rTmNwg@mail.gmail.com>
References: <CAJ8eaTxyODK+VFwK2csbxSs7LzAe2EqMXemxFRYF+A26rTmNwg@mail.gmail.com>
Date: Wed, 12 Jun 2013 10:46:39 +0530
Message-ID: <CAJ8eaTwcLJPQ_HD_XirQnO5C_0kZmmp6rxCZSYOBwCqD4-sYaA@mail.gmail.com>
Subject: Fwd:
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,


We are facing one issue in user space, if we enable thumb mode and in kernel
whether we enable or disable thumb mode or code run in both scenario.
we could not understand the reason.

Our core is ARM cortex A15,
Kernel 3.8.13

One more issue if we disable THUMB in kernel we got undefined instruction in


11dffd:    ee7  7a00      vmov.f32        s15,#112    ;0x70
