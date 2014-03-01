Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaCAAlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:41:10 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54587 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbaCAAks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:40:48 -0500
Message-ID: <53112C8B.2000504@hurleysoftware.com>
Date: Fri, 28 Feb 2014 19:40:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Ray Strode <halfline@gmail.com>, Kay Sievers <kay@vrfy.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Subject: Re: [PATCH] tty: Add sysfs symlink for console name->tty device
References: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com> <20140301003549.GB31852@kroah.com>
In-Reply-To: <20140301003549.GB31852@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 07:35 PM, Greg Kroah-Hartman wrote:
> On Wed, Feb 26, 2014 at 09:40:51AM -0500, Peter Hurley wrote:
>> Enable a user-space process to discover the underlying tty device
>> for a console, if one exists, and when the tty device is later
>> created or destroyed.
>
> What userspace code has been tested with this change?

Every existing distro + personal copies going back 42 versions.
No breakage. ;)

>> Add sysfs symlinks for registered consoles to their respective
>> devices in [sys/class,sys/devices/virtual]/tty/console.
>> Scan consoles at tty device (un)registration to handle deferred
>> console<->device (un)binding.
>
> I don't understand, what does userspace now look like in sysfs?  Do we
> need Documentation/ABI/ updates here?
>
> And David has fixed up his original patch, which doesn't break plymouth,
> and I'll be taking that, so I don't see why this patch is needed.

Ok. I tried.

Regards,
Peter Hurley

