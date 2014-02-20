Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaBTOje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:39:34 -0500
Received: from dd8000.kasserver.com ([85.13.132.92]:57377 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaBTOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:39:33 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 09:39:32 EST
Message-ID: <53061204.7080700@gmx.net>
Date: Thu, 20 Feb 2014 15:32:36 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [3.14-rc3] possible regression Haswell runs only at 770Mhz with powersave
 governor
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My System which runs with older kernels up to 3.13.3
fine on my i3-4330 with 3.5 Ghz and governor powersave.
and pstate driver.

With kernel 3.14-rc3 and Governor powersave it runs
only at 770Mhz and never switches to higher Freq. on load.
Even compiling a kernel with make -j4   does not change freq.

With governor performance  it switches to 3.5 Ghz and stays
there.

Any Idea how to fix this?

Best regards
