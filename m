Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbbAZX3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:29:39 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbbAZX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:29:37 -0500
Message-ID: <54C6CDDC.5010507@nod.at>
Date: Tue, 27 Jan 2015 00:29:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Scot Doyle <lkml14@scotdoyle.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] fbcon: user-defined cursor blink interval
References: <alpine.DEB.2.11.1501262305150.2783@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.11.1501262305150.2783@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 00:09 schrieb Scot Doyle:
> Since users prefer different fbcon cursor blink intervals, allow the
> interval to be set via sysfs. The current interval of 200 milliseconds
> is retained as the default. Tested with intelfb.
> 
> v2:  Use kstrtos16() instead of kstrtoul() and min_t() as suggested by
>      Geert Uytterhoeven
> v3:  Add error messages as suggested by Tomi Valkeinen
> v4:  Add rationale into patch descriptions as suggested by
>      Richard Weinberger

Hehe, no need to resend immediately a v4, I'm just curios about the use case. :)
Why do users want a different blink interval? What is the use case?
And what are these users? Most people use a fbcon only for a few moments
to fix/restart X11.

Thanks,
//richard
