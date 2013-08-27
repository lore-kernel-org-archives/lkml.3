Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3H0PkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:40:21 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56915 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808Ab3H0PkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:40:19 -0400
Message-ID: <521CC85D.6000009@hurleysoftware.com>
Date: Tue, 27 Aug 2013 11:40:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
References: <521AED72.8050105@xs4all.nl>
In-Reply-To: <521AED72.8050105@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Greg KH, Jiri S ]

On 08/26/2013 01:53 AM, Udo van den Heuvel wrote:
> Hello,
>
> I am stuck with a weird keyboard related issue:
> Since a few weeks I see loads of ^@^@^@^@^@^@ appear on the text console
> while the PC_speaker beeps when this box is in runlevel 3.
> When xorg is running the ^@^@^@ stream stops, as does the beeping, but I
> can notice that selecting text, scrolling xterminals with the mouse are
> interrupted by these characters appearing. (but not printing)
>
> Removing/replacing the ps/2 keyboard does not help.
> Rebooting does help for a while.
>
> The hardware is a Gigabyte F2A85X-UP4, BIOS F5a 04/30/2013.
> I replaced the board last weekend by a brand new F2A85X-UP4 with same
> BIOS F5a but the problem persists.
>
> What could this be?
> Is it really a software issue?
> If so: how could I help fix this?

What changed 'a few weeks' ago when this problem started?
I noticed your USB post as well. Did that problem start at the same time
with the same change?

Regards,
Peter Hurley

