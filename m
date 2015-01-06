Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbbAFTM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:12:26 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33141 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAFTMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:12:24 -0500
Message-ID: <54AC3395.9080101@hurleysoftware.com>
Date: Tue, 06 Jan 2015 14:12:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.19-rc3
References: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 01/06/2015 04:36 AM, Geert Uytterhoeven wrote:
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

[snip]

>   + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: warning: 'flags' may be used uninitialized in this function:  => 3186:16

Is there some way of finding out what gcc + config produced this warning?

I know what commit produced this build regression but I'm not seeing a problem
with the code.

Regards,
Peter Hurley
