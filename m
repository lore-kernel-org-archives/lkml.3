Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3CEXGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:06:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3CEXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:06:18 -0500
Date: Tue, 5 Mar 2013 15:06:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        David Sterba <dsterba@suse.cz>, Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 0/5] Add support for LZ4-compressed kernel
Message-Id: <20130305150616.cb737f9b217b8c82051b2ccb@linux-foundation.org>
In-Reply-To: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Mar 2013 20:47:31 +0900 Kyungsik Lee <kyungsik.lee@lge.com> wrote:

> This is the third version. In this version, Some codes are fixed
> and more description and note are added. I would like to thank David Sterba
> for his review.
> 
> The Last patch[5/5] of the patch set is for making x86 and arm default to
> LZ4-compressed for testing the LZ4 code in the linux-next.
> It was requested by Andrew Morton in the patch set v2.
> 
> Currently, A preliminary version of LZ4 de/compression tool is supported.
> However, It is expected that we will have a tool with more features
> once its format is finished.

What happened to the changelog?  The earlier version at least had some
rudimentary benchmarking results, but now we don't even have that. 

Someone should prepare the information explaining why we added this to
Linux, and I'd prefer that person be you rather than me!  Certainly it
should include performance measurements - both speed and space.  Also
it should capture our thinking regarding all the other decompressors,
explaining why we view it as acceptable to add yet another one.

Please, put yourself in the position of someone reading these commits
in 2017 wondering "why did they merge this".  We should tell them.

