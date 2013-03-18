Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3CRCyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:54:44 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:37564 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3CRCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:54:41 -0400
MIME-Version: 1.0
Date: Mon, 18 Mar 2013 10:54:40 +0800
Message-ID: <CAKuKa0grrdQf3own8SorpswC8i9b7517D65pYJVrXiHHPQCXLg@mail.gmail.com>
Subject: Does kexec/kdump support 32bit user App with 64 bit kernel?
From: bigboy <snakky.zhang@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

For kexec and kdump, I have a question about 32/64 bits. In such an environment
that 64 bits kernel with 32bit kexec-tools. Can the kdump works in order?

>From code review, the 32bit kexec-tools wil make a 32bit ELF header while the
64bits dump-kernel will check the very ELF header and then deny it for this
reason. Does this is designed? Or can it be resolved/workaround?

Thanks a lot
Xiao
