Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab3CFOgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:36:32 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:53983 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3CFOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:36:29 -0500
Message-ID: <5137546B.2090801@free-electrons.com>
Date: Wed, 06 Mar 2013 15:36:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: 3.9-rc1: hz.bc compilation breakage
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm compiling the kernel for an iMX28(ARM) board, and since 3.9-rc1, I
get the following error at compilation time:

make[3]: *** No rule to make target
`/home/max/Work/2012/crystalfontz/rewrite/linux-dt/include/config/hz.h',
needed by `kernel/hz.bc'.  Stop.

I'm doing a clean out-of-tree build, with the following configuration
file: http://code.bulix.org/m4y7se-83102?raw

Reverting commit 1b66e0fd ("kernel: Replace timeconst.pl with a bc
script") make the compilation go on as usual.

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
