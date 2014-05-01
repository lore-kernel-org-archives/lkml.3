Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaEAQRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:17:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34801 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaEAQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:17:53 -0400
Date: Thu, 1 May 2014 09:17:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: powerpc:allmodconfig build failure (since 3.14)
Message-ID: <20140501161746.GA7375@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the powerpc:allmodconfig build has been broken since 3.14
with the following error.

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1315: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

Any chance to get this fixed, or is it time to drop powerpc:allmodconfig
from my test builds ?

I would give it a shot myself, but that file is one that I would prefer
not to touch.

Thanks,
Guenter
