Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3IMFEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:04:55 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62501 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3IMFEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:04:40 -0400
Date: Thu, 12 Sep 2013 22:04:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [00/23] 3.4.62-stable review
Message-ID: <20130913050437.GA25523@roeck-us.net>
References: <20130912174451.748805761@linuxfoundation.org>
 <20130912174451.948344919@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912174451.948344919@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odd, the 00/23 mail for 3.4.62 doesn't show up on lkml.
So this mail will most likely show up as reply to 01/23.

Anyway, here are my build results for 3.4.62:
	total: 103 pass: 89 skipped: 10 fail: 4

More configurations (added two crisv32 as well as several arm builds),
one less failure (m32r:defconfig now builds).

qemu: microblaze, mips, mips64, ppc, sh, x86, x86_64 pass
	qemu:arm doesn't work with the 3.4 kernel and was skipped.

sh results are new. As with other qemu results, qemu needs to be patched
to work for the sh target.

Details are at http://server.roeck-us.net:8010/builders.

Guenter
