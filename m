Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbaLLK1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:27:52 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53740 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaLLK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:27:50 -0500
MIME-Version: 1.0
In-Reply-To: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
From: Guan Xin <guanx.bac@gmail.com>
Date: Fri, 12 Dec 2014 11:27:08 +0100
Message-ID: <CANeMGR5YJKwJtK5RKkz5fJAn+F1x27f5jmqbyFz8ustqhGz2=w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        texstar@gmail.com, martin@mvath.de, Bruno Wolff III <bruno@wolff.to>,
        dave@vasilevsky.ca, szycha@gmail.com, blyons@students.naropa.edu,
        tokiclover@gmail.com, afm404@gmail.com, hugochevrain@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

Thank you for your work on squashfs and your persistent effort on mainlining
squashfs-lz4 support!

I've been using squashfs with lz4 compression (together with aufs by Okajima)
for my desktop, laptops, home router and bluetooth music player for about
half a year. There was not a single issue. All I got were reduced latency
compared to lzo compression, and drastically increased compression speed.
The later is important to me because my application requires re-mksquashfs of
the whole system in order to make software updates permanent.

lz4 support (especially with -Xhc) is not only helpful, but also a
valuable addition
to squashfs.

Regards,
Guan
