Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3K0J7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:59:31 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44388 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3K0J71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:59:27 -0500
Date: Wed, 27 Nov 2013 10:59:14 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Evolution of Linux kernel sizes
Message-ID: <20131127095914.GA4609@netboy>
References: <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:35:25AM +0100, Geert Uytterhoeven wrote:
> For v3.13-rc1, the top 10 is:
> 
> Disabling CONFIG_NET saves 1038404 bytes
> Disabling CONFIG_INET saves 572034 bytes

...

> I hope you find this useful!

As another poor soul stuck with tiny resources, thank you for this
work! Now, if I could only leave networking out...

Thanks,
Richard
