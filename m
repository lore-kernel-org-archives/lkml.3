Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3KPFrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 00:47:41 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:35790 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3KPFrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 00:47:39 -0500
MIME-Version: 1.0
Date: Sat, 16 Nov 2013 13:47:38 +0800
Message-ID: <CAK2Ky6z3PS-HEPFEh7XW7Op=JQowjKCHRURO76amWVDRSq=pMg@mail.gmail.com>
Subject: About deadline IO scheduler in kernel
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In deadline scheduler, in a FIFO list when  a request insert it and
other request remove it in the same time,whether it make conflict???
Whether it need lock??
Thank you!
