Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3GUVOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 17:14:00 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:60263 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3GUVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 17:13:59 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2013 17:13:59 EDT
Message-ID: <51EC4D77.2010502@mni.thm.de>
Date: Sun, 21 Jul 2013 23:07:03 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Thunderbird/25.0a1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
In-Reply-To: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.2013 21:53, Linus Torvalds wrote:
> So it's been another week, and -rc2 is out there.
...
>
>   (b) we had a late change to how ACPI backlight handling is done on
> certain machines, and while this kind of thing really shouldn't be
> done outside the merge window, I ended up pulling it anyway. But I'd
> *really* like to have people test this thing particularly on laptops
> with intel-based graphics. It should only matter (and hopefully
> improve things) for the newer ones with BIOSes designed for Windows 8,
> but hey, the more testing, the better. Backlight handling has been
> painful before, so I'm mentioning this explicitly.
>

This pach finally fixes my backlight control!

Thanks!
Tobias Klausmann
