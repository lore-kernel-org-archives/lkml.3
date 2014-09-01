Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIANnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:43:39 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60162 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIANni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:43:38 -0400
MIME-Version: 1.0
Date: Mon, 1 Sep 2014 16:43:37 +0300
Message-ID: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  void *__seq_open_private(struct file *f, const struct seq_operations *ops,
> - int psize)
> + size_t psize)

It should be "unsigned int" at most.
As almost all in-kernel lengths.

    Alexey
