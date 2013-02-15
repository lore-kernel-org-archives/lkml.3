Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838Ab3BOMkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:40:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab3BOMkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:40:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/9] ARM: omap: add include guard for soc.h
Date: Fri, 15 Feb 2013 12:40:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-5-git-send-email-arnd@arndb.de> <20130214225526.GH11362@atomide.com>
In-Reply-To: <20130214225526.GH11362@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151240.22673.arnd@arndb.de>
X-Provags-ID: V02:K0:C/DWpwHhXufLuaNFjQBrlVrlKEsGbr9NjtkaLjzxeF2
 r69O5VzsDbMnXvIFBc7XDHz/8uNRilkOeY+GTp4ribLlgDwjie
 GH4zevF6/nQN5uGM6KM92KzDsIrwo7t0Ugk3RAhpqJXOMfqWPB
 bHd1HEAiIbcBrLMAK4BvkGDlI+GkMmGlqztbmxQ1ecmgiAIzoq
 SGsMsWLF7+C9JtHfyyFrc8uirxYWwF/z7JkQmjDUhVsl10i3f8
 sdZdyWyFlUhPqoVyea4vXRmPl26O4tiiAs+Ul4DHJhffT5PuGk
 BglIKRhvv8J6TMUDu+dvMuDYxHvul6ebi4YT2RBqiZK0QGw5vv
 xaMHVTyzgw8yl+Iv9cCU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Tony Lindgren wrote:
> I left it out intentionally as these are private to mach-omap2,
> and I'd like to simplify the indirect includes there further.
> So I'd rather just remove the duplicate soc.h from drm.c.
> 
> If people really think this should be applied, I have no
> objections to this patch naturally.

The duplicate #include was a result of an automated mismerge between
v3.8-rc5 and the omap/multiplatform branch. I have merge v3.8-rc5
into next/multiplatform to resolve this correctly, and pulled in
a new omap/multiplatform-fixes branch with patches 6, 7, and 9
from this series.

	Arnd
