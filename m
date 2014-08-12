Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaHLLoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:44:19 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:59460 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaHLLoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:44:08 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 14:44:06 +0300
Message-ID: <CACVxJT9vq=uAvB9pVpACp-V_2Q7nRpp2QdA1C3azKx+x4BXe5g@mail.gmail.com>
Subject: Re: [PATCH] kernel:audit Fixed some coding style errors and warnings.
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ionut.m.alexa@gmail.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - audit_default = !!simple_strtol(str, NULL, 0);
> + int rc = kstrtol(str, 0, (long *)&audit_default);

obviously broken
