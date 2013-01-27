Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3A0Q34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:29:56 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:40241 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3A0Q3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:29:52 -0500
Message-ID: <510555C4.4020502@ahsoftware.de>
Date: Sun, 27 Jan 2013 17:28:52 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Include kernel config by default
References: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.01.2013 14:34, schrieb Alexander Holler:
> Hello,
>
> I've seen too many systems where the config to build the used kernel got
> lost and people were unable to diagnose problems or to rebuild a modified
> or updated kernel. It's a subject which worries me since several years.
>
> Therefor I finally prepared the following patch(es) to include the config
> by default, make it by default accessible through /proc/config.gz, to
> hide the option to not include the config below "embedded" and to remove all
> now unnecessary IKCONFIG_* options from 174 defconfigs (almost all of them
> enabled those options explicit).
>
> I've already posted that two times before
> (https://lkml.org/lkml/2012/7/25/2 and https://lkml.org/lkml/2012/10/18/132)
> without even getting a single response. So I don't know if it's a totally
> foolish idea, if nobody is interested, or if the previous patches just weren't
> seen by anybody.
>
> I've now added the maintainers of the two large architectures (x86 and arm), the
> master himself and a few other people to cc (sorry if I've missed any important
> person), and I made the subject more clearly.
>
> Maybe this will provoke at least a single response. ;)

To add a last note:

I really only care about the first patch which sets the default to y. 
The other two patches are more or less "nice to have" (imho) and the 
third patch could be even splitted into 14 patches (one for every 
architecture) or even 174 singles patches (one for every board(-type). 
If requested I would split the third patch.

But now I'm finished. ;) So if no one responses (or feels responsible), 
I won't bother again through sending them again.

Regards,

Alexander
