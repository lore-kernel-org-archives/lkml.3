Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3AUWaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:30:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3AUWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:30:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Sealey <matt@genesi-usa.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Date: Mon, 21 Jan 2013 22:30:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <CAKGA1bn0-83d+BFRMGZDZ9MZ2nnx8e8wh-VS3XoG5UQJDC0npg@mail.gmail.com>
In-Reply-To: <CAKGA1bn0-83d+BFRMGZDZ9MZ2nnx8e8wh-VS3XoG5UQJDC0npg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212230.07393.arnd@arndb.de>
X-Provags-ID: V02:K0:xv3sYwDw5x7ImU48EGy52DYvdpjiCp0wQbyyV66/BE2
 qgNJYaZOHAczkqNJre6qyP5ndSjrE4zCyVp8bblNEECKYgYCK8
 bxdfaaskpS0Q+6W69mD1PAcHNOxS3MVWCqfzCEz2I+dHH41QnB
 BA3m6oKZ9OdJljTRUgkcTcpe4lXpX+MM5TSJHsNcW88IE7yOEf
 SofZU+C+iz27JP2BInJRsilXF3JDlrcCFAurhZ5ob/ZqqLFQze
 Pgl2qiqLQQsuCYcr5q5qiMLi790vCGO3BsCddT7zVhUlb7rPHz
 oxqVXkwvo0YYHahW/rKmdpazTvMf0IQwsLGT6oiwHcMumkguUD
 2x9gq2Aqp3LLibaehbu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Matt Sealey wrote:
> So is that a bug in that it is not available to ARM right now, a bug
> in that it would be impossible for anyone on ARM to have ever tested
> this code, or a bug in that it should NEVER be enabled for ARM for
> some reason? John? Ingo? :)
> 

I think it's a bug that it's not available. That does not look intentional.

	Arnd
