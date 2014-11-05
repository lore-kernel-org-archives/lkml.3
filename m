Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaKEIDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:03:12 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:58970 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaKEIDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:03:09 -0500
MIME-Version: 1.0
Date: Wed, 5 Nov 2014 13:33:08 +0530
Message-ID: <CAOD=uF4L+jvR=ckMdo3o4wdSsRcGynQnv_KOpDeyJst74YOxuA@mail.gmail.com>
Subject: How to access Linux Kernel environment Variables ?
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is there any system call in Linux which serve the purpose of  "kenv()"
of FreeBSD ?


In FreeBSD:
-----------------
Kernel environment variables are saved at "/boot/loader.conf"  and
those variables can be accessed using "kenv()"  system call in C
program.
----------------


Is there any similar functionality available in Linux kernel ?


Thanks
Santosh
