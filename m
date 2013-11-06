Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab3KFIzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:55:42 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38070 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3KFIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:55:40 -0500
MIME-Version: 1.0
Date: Wed, 6 Nov 2013 14:25:39 +0530
Message-ID: <CAJ8eaTzwbuhTPkyjQrXFwJT_fZ4CEoBX3o9Wt6E_1Lv5DOs_nw@mail.gmail.com>
Subject: Info about which CPU is in Trustzone
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

We are running ARM cortex A15 (4 core), with Kernel 3.8. we have
enable Trustzone feature also.
We want is there any way to find at a particular time, how many core
are involve in Trust zone mode and what are there number.

Ex. 2 core involve core 1, core 3

Thanks
