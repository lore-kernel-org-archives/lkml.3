Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaBUWrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:47:07 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45441 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbaBUWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:47:04 -0500
Date: Fri, 21 Feb 2014 14:47:06 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL] integrator base patches for v3.15
Message-ID: <20140221224706.GC13233@quad.lixom.net>
References: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 01:35:38PM +0100, Linus Walleij wrote:
> Hi ARM SoC folks,
> 
> this is a set of patches I have sent for review and failed to get
> ACKs from the proper subsystem maintainers after repeated
> pings. However I now need to have this rotated in linux-next
> as a base for multiplatform, so please pull it in, it is all ARM
> drivers anyway. Russell pointed out some things and these
> have been fixed and iterated in this series.
> 
> Yours,
> Linus Walleij
> 
> The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:
> 
>   Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git
> tags/integrator-for-v3.15-1
> 
> for you to fetch changes up to 29525484cd2524a31ee0924831ab43b46ea6ebe1:
> 
>   ARM: integrator: select GPIO block (2014-02-13 11:21:37 +0100)

These patches are a little all over the place -- some is new dt bindings, some
are driver cleanups, etc. I ended up merging it into next/drivers since that's
what the bulk of the changes were in this time.

So, pulled. Thanks.


-Olof
