Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FNHGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:06:49 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60787 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3FNHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:06:47 -0400
Date: Fri, 14 Jun 2013 08:06:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: Re: [PATCH Resend 1/1] mfd: davinci_voicecodec: Convert to use
 devm_* APIs
Message-ID: <20130614070641.GB28134@laptop>
References: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
 <20130613104943.GD16677@laptop>
 <CAK9yfHxJGtC5i8SQ0TLCzvXQwgskxAX5rpFsbNAnQvkSWqW0VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHxJGtC5i8SQ0TLCzvXQwgskxAX5rpFsbNAnQvkSWqW0VQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Sachin Kamat wrote:

> Hi Lee,
> 
> On 13 June 2013 16:19, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 12 Jun 2013, Sachin Kamat wrote:
> >
> >> devm_* APIs are device managed and make code simpler.
> >>
> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> >> ---
> >> CC'd Lee Jones
> >
> > Can you resubmit this based on -rc5 please?
> >
> > There have been some related changes since you wrote this patch.
> 
> This patch is based on Samuel's mfd-next tree [1].
> This patch is dependent on your patch "mfd: davinci_voicecodec:
> Convert to managed resources for allocating memory"
> which is applied in mfd-next.
> 
> Please let me know which other tree you want me to rebase this patch
> on considering the dependency.
> 
> [1] http://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git

I believe Sam's branch has been updated considerably since you wrote
the patch. Would you mind rebasing it onto Sam's latest master branch
please? Should be commit: d8c5d658f425bd25bbfb137f2617f59ed4fdee7d.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
