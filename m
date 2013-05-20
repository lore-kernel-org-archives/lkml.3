Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab3ETVoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:44:06 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:50162 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758411Ab3ETVoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:44:05 -0400
Message-ID: <519A9920.3010702@hurleysoftware.com>
Date: Mon, 20 May 2013 17:44:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] tty: Add lock/unlock ldisc pair functions
References: <20130415201411.GA27360@kroah.com> <1366107356-7699-1-git-send-email-peter@hurleysoftware.com> <1366107356-7699-2-git-send-email-peter@hurleysoftware.com> <20130520193403.GA14340@kroah.com>
In-Reply-To: <20130520193403.GA14340@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 03:34 PM, Greg Kroah-Hartman wrote:
> On Tue, Apr 16, 2013 at 06:15:51AM -0400, Peter Hurley wrote:
>> Just as the tty pair must be locked in a stable sequence
>> (ie, independent of which is consider the 'other' tty), so must
>> the ldisc pair be locked in a stable sequence as well.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 87 insertions(+)
>
> This patch breaks the build :(

Sorry about that.

> I've taken the first one, care to mush this one with the 7/7 patch, so
> there are no build breaks, and resend the 5 resulting patches so I can
> apply these?

Maybe it would be better to reorder 7/7 to be 1/6, if that's ok?
More work for me but the history will be cleaner.

Regards,
Peter
