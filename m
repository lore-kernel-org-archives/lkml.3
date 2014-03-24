Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaCXV2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:28:39 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40004 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaCXV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:28:37 -0400
Date: Mon, 24 Mar 2014 17:28:35 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Anders Berg <anders.berg@lsi.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Fredrik_Markstr=F6m?= <fredrik.markstrom@gmail.com>
Subject: Re: [PATCH RFC] ARM: mm: Fix for highmem on machines with more than
 14 cores
In-Reply-To: <52661057074abf5bfe6174cb561bec5eea8892fb.1395692531.git.anders.berg@lsi.com>
Message-ID: <alpine.LFD.2.11.1403241727290.1291@knanqh.ubzr>
References: <cover.1395692531.git.anders.berg@lsi.com> <52661057074abf5bfe6174cb561bec5eea8892fb.1395692531.git.anders.berg@lsi.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1906557635-1395696516=:1291"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1906557635-1395696516=:1291
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 24 Mar 2014, Anders Berg wrote:

> The fixmap area was hard coded to 224 pages which was only enough for 14 CPU:s.
> Now the area adapts to the configured number of CPU:s (NR_CPUS). We still have
> a hard limit of 30 CPU:s since we only have a single pte-chunk (512 pte:s).
> 
> Signed-off-by: Anders Berg <anders.berg@lsi.com>
> Signed-off-by: Fredrik Markström <fredrik.markstrom@gmail.com>

This is under discussion already.  Please have a look at this thread:

http://news.gmane.org/group/gmane.linux.kernel/thread=1672068/


Nicolas
--8323328-1906557635-1395696516=:1291--
