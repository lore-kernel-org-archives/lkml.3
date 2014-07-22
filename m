Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaGVEYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:24:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45351 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaGVEYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:24:06 -0400
MIME-Version: 1.0
Date: Tue, 22 Jul 2014 00:24:05 -0400
Message-ID: <CAPDOMVhUkF49L1jJgfXdRdMW2qkGsbPfGVwrdaETqTUs3bEcsQ@mail.gmail.com>
Subject: decompress.c : Add cache support
From: Nick Krause <xerofoify@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, antonynpavlov@gmail.com, blogic@openwrt.org,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ralf and others
We seem to be flushing this cache after decompressing the kernel on
mips. Can't we cache this?
If anyone has any advice on how to fix this it would be great:).
Nick
