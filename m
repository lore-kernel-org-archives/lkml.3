Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaBDB2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:28:17 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41764 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBDB2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:28:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: David Rientjes <rientjes@google.com>,
        "Alexey Dobriyan" <adobriyan@gmail.com>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <alpine.DEB.2.02.1402031704430.32346@chino.kir.corp.google.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
        "Joe Perches" <joe@perches.com>
References: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org>
 <CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com>
 <alpine.DEB.2.02.1402031704430.32346@chino.kir.corp.google.com>
Message-ID: <20140204012816.22878.4159@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: + mm-utilc-add-kstrimdup.patch added to -mm tree
Date: Mon, 03 Feb 2014 17:28:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Rientjes (2014-02-03 17:05:04)
> The last we heard, I think Sebastian is looking to redo this series and 
> this patch is no longer needed.  Sebastian?
Hi David, Alexey,

I am in the process of reworking the patches.  I'm not sure if Andrew
was just interested in having the kstrimdup utility function available.

Isn't it too late to impose userspace trimming of newlines for sysfs?
It seems already fairly common and expected for the kernel to eat the
trailing whitespace, or at least ignore it.  If we change this won't we
be breaking userspace / tools / instructions / etc?

I'll try to post the new patches soon.

Thanks,

Sebastian

