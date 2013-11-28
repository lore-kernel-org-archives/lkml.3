Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3K1Kxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:53:37 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46139 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3K1Kxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:53:35 -0500
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Thu, 28 Nov 2013 18:53:12 +0800
X-Google-Sender-Auth: WtU17OkghQs1TFDrdwTdelKAR4c
Message-ID: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
Subject: How to create a config that doesn't set CONFIG_PROC_FS
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if I use `make allnoconfig`, CONFIG_PROC_FS is still set. So I'm
wondering how to create a config without CONFIG_PROC_FS for build
testing?


Thanks,
Tao
