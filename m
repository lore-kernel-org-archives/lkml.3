Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3HPIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:07:41 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50955 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3HPIG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:06:29 -0400
MIME-Version: 1.0
Date: Fri, 16 Aug 2013 16:06:26 +0800
X-Google-Sender-Auth: iw4tt8b-b2QeA3RygG2v09uL1Ks
Message-ID: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
Subject: System suspend states and device driver suspend() callback
From: Li Yang <leoli@freescale.com>
To: linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Is there a standard way for the device drivers to know if the system
is going to “standby” mode or “mem” mode when the suspend() callbacks
are called?

Regards,

Leo
