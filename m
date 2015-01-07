Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbbAGIzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:55:10 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:52927 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbbAGIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:55:08 -0500
Message-ID: <54ACF45E.4020100@synopsys.com>
Date: Wed, 7 Jan 2015 14:24:54 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.19-rc3
References: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tuesday 06 January 2015 03:06 PM, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.19-rc3[1] compared to v3.18[2].
> 
> Summarized:
>   - build errors: +86/-19
>   - build warnings: +242/-127
> 
> JFYI, when comparing v3.19-rc3[1] to v3.19-rc2[3], the summaries are:
>   - build errors: +64/-9
>   - build warnings: +123/-75
> 
> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.
> 
> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.19-rc3.summary.gz
> 
> Happy fixing! ;-)
> 
> Thanks to the linux-next team for providing the build service.
> 
> [1] http://kisskb.ellerman.id.au/kisskb/head/8277/ (255 out of 262 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (all 262 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8257/ (all 262 configs)

How can I get the ARC tools / config added to test setup.
AFAIKR linux-next already has ARC setup as I got a build failure report from them
once [1]

[1] https://lkml.org/lkml/2014/9/25/767

Thx,
-Vineet
