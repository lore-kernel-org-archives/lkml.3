Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701Ab3DHJdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:33:11 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:39587 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3DHJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:33:09 -0400
Date: Mon, 8 Apr 2013 10:33:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: cbouatmailru@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AB8500 Power and MFD related updates
Message-ID: <20130408093303.GF3084@gmail.com>
References: <20130307043859.GA11944@gmail.com>
 <20130408091851.GI24058@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130408091851.GI24058@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> > The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:
> > 
> >   Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd-and-power
> I was expecting to get an MFD only branch (Basically what your for-mfd branch
> looks like, and then the for-mfd-and-power one to be based on the mfd only
> with the power patches applied on top of it.
> Now, I have to pull the power patches as well, which is no big deal but not
> ideal neither.

Sorry Sam, I guess I understood you differently:

"I can Ack the MFD parts, they look good to me. And then you can take
the whole thing through your tree, but I'd prefer you to do so by
pulling the branch Lee prepared for us. I want to avoid conflicts this
way."

When you said you wanted the "whole thing" to go through Anton's Tree,
I thought that's what you meant?

> Anyway, I pulled this branch into mfd-next, with a tiny conflict.

Okay, that's good.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
