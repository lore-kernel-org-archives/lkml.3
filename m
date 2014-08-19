Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaHSIGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:06:39 -0400
Received: from mout.gmx.net ([212.227.15.19]:52278 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaHSIGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:06:37 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com
Subject: Re: [PATCH v2 3/4] zram: zram memory size limitation
Date: Tue, 19 Aug 2014 10:06:22 +0200
Message-ID: <7959928.Exbvf4HrNB@fb07-iapwap2>
User-Agent: KMail/4.13.3 (Linux/3.17.0-rc1-12.gfc9498b-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1408434887-16387-4-git-send-email-minchan@kernel.org>
References: <1408434887-16387-1-git-send-email-minchan@kernel.org> <1408434887-16387-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V03:K0:dWTODOrFxvsP5D3TRwaav5aZDYvPMJcy6w1evkjXMA8dmkWThrF
 OI0yv4g2/bu8+Rs3FWMmtMs9Ku1l9vVAN1wuHpFa5QDIcUr6ofMBCiAaRK2t6c8VmtK0thW
 omzSGSnABlgUZwXzD21G4pz5rXAhX6n5H1G3puDbQpdGqughSxKwwvYRiFee5u3p0T+Kwvg
 R35selbsg6I2wj/V0Rqzw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. August 2014, 16:54:46 schrieb Minchan Kim:
> Since zram has no control feature to limit memory usage,
> it makes hard to manage system memrory.
> 
> This patch adds new knob "mem_limit" via sysfs to set up the
> a limit so that zram could fail allocation once it reaches
> the limit.

Sorry to jump in late with a probably silly question, but I couldn't find the 
answer easily. What's the difference between disksize and mem_limit?
I assume the former is uncompressed size (virtual size) and the latter is 
compressed size (real memory usage)? Maybe the difference should be made 
clearer in the documentation.
If disksize is the uncompressed size, why would we want to set this at all?

Marc

