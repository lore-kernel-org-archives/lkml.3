Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3B0KhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:37:23 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55231 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3B0KhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:37:22 -0500
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Wed, 27 Feb 2013 18:37:00 +0800
X-Google-Sender-Auth: Q35a_UJyUwX72de99qhsjUVxUhs
Message-ID: <CA+a=Yy5FkgAK5Cr_qQ7jTSZbWCDA073VJ9b3nVqA9M6J=Sy=iw@mail.gmail.com>
Subject: Why create_kthread passes SIGCHLD to kernel_thread?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looking at do_fork(), it seems that SIGCHLD is used to tell what kind
of trace event to report but kernel_thread() certainly doesn't want
any of it. So what does this SIGCHLD mean for create_kthread?

-- 
Thanks,
Tao
