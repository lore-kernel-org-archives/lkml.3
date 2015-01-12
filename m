Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbALPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:42:22 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62566 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbbALPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:42:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Date: Mon, 12 Jan 2015 16:42:14 +0100
Message-ID: <3791313.iJ2hL8LhRB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150112142332.GC19807@e104818-lin.cambridge.arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <23318125.rGnCbWvYBR@wuerfel> <20150112142332.GC19807@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:JjkA86GgrgWjBDILAwNOxwArKRrRwn8U56O1bzpRKRhCmuZlnrm
 Kh1a1HZ3y/2aR5tZ70eJfhwfHcB6AUjAZy+IjBAupvakcHCtbZ4FAGT8nntfEBeo/kobQjF
 Xc4siQlPfE41eGoIU5tZsAepLuITFboVwmYIkEW5AqZ8NGOtGd/5r237FxMj2jk/OL3vOOd
 sdkhkKaB5AaoqwJml+nwA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 14:23:32 Catalin Marinas wrote:
> 
> So, I guess it's run-time cost of the LRU algorithm, especially under
> memory pressure. Harder to benchmark though (we'll see when we get
> hardware, though probably not very soon).

One thing you could try is to add an access fault handler that gathers
statistics about number of calls (you could trivially get this by
using gcov) and time spent in the handler for a workload that causes
memory pressure.

	Arnd
