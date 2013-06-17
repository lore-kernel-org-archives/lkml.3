Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3FQUcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:32:18 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34442 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486Ab3FQUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:32:17 -0400
Message-ID: <51BF724A.505@hurleysoftware.com>
Date: Mon, 17 Jun 2013 16:32:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v4 00/24] lockless n_tty receive path
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com> <1371302076-4688-1-git-send-email-peter@hurleysoftware.com> <20130617200138.GA8199@kroah.com>
In-Reply-To: <20130617200138.GA8199@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 04:01 PM, Greg Kroah-Hartman wrote:
> On Sat, Jun 15, 2013 at 09:14:12AM -0400, Peter Hurley wrote:
>> Greg,
>>
>> As before, this patchset is dependent on the 'ldsem patchset'.
>> The reason is that this series abandons tty->receive_room as
>> a flow control mechanism (because that requires locking),
>> and the TIOCSETD ioctl _without ldsem_ uses tty->receive_room
>> to shutoff i/o.
>>
>> It is also dependent on 'n_tty fixes' which I recently resent
>> to you.
>
> Thanks for rebasing all of this, and resending it.  It's late in the
> 3.11 development cycle, so I'm going to wait unto 3.11-rc1 is out to
> queue it up for 3.12, to get it lots of testing in linux-next.

Thanks Greg. I actually meant to suggest these be held until after
the merge window but I got distracted by the VT1 deallocation bug
report.

Regards,
Peter Hurley
