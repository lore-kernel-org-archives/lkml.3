Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbbAFSyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:54:22 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56289 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAFSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:54:21 -0500
Message-ID: <54AC2F5D.9050405@linaro.org>
Date: Tue, 06 Jan 2015 18:54:21 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Joe Perches <joe@perches.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: kgdb-next not pushed to Linus for 3.19
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason

I'm trying to figure out what to do with my long-outstanding kgdb/kdb
patches in preparation for the 3.20 merge window.

As of now I have five pending patch sets some of which are well over six
months old (and none have nay outstanding review comments).

When I raised this with you a couple of months ago, two of the patch
sets did land in your kgdb-next tree. However nothing seems to have
happened since then and I couldn't find any messages from you during the
3.19 merge window.

I'm afraid I don't know what else I need to do to progress things.

I do plan to do routine rebasing and resending of my patchsets but,
based on the past experience, that seems unlikely to be enough to get
the code delivered in 3.20.

Do you think I would be better sending these patches via someone else?
In any case, advice would be very welcome.


Daniel.

