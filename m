Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaAHLaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:30:08 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35573 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAHLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:30:06 -0500
MIME-Version: 1.0
Date: Wed, 8 Jan 2014 19:30:04 +0800
Message-ID: <CAB-gxZAkGJpZjQMbhAm=Wip1wpm=oUvw_rUQpTkGb+n+qsgL0w@mail.gmail.com>
Subject: how to use memmap= option
From: Long Wind <longwind2009@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have asked Debian users, they don't seem to know
kernel 2.4/2.6 fail to boot on my PC
probably because it can't detect my memory
so I have to tell kernel memory map

the following is copied from kernel-parameters.txt:

memmap=exactmap	[KNL,X86] Enable setting of an exact
			E820 memory map, as specified by the user.
			Such memmap=exactmap lines can be constructed based on
			BIOS output or other requirements. See the memmap=nn@ss
			option description.



Could you tell me how to construct memmap= lines?
