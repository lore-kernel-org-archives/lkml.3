Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3AQSvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:51:16 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:34705 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3AQSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:51:10 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130117181720.GA12352@kroah.com>
References: <1357634896-9944-1-git-send-email-sedat.dilek@gmail.com>
	<20130117181720.GA12352@kroah.com>
Date: Thu, 17 Jan 2013 19:51:09 +0100
Message-ID: <CA+icZUUdZHSa5OLfPUbxw2MVqG5LvV=dPrprQBciWPCUeNRO_w@mail.gmail.com>
Subject: Re: mei: Fix typo "@hader" in mei_write_message()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 7:17 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 08, 2013 at 09:48:16AM +0100, Sedat Dilek wrote:
>> This was introduced by:
>>
>> commit 438763f37eb9664b6372bdfee990f8c33acdc63c
>> "mei: drop redundant length parameter from mei_write_message function"
>>
>> First seen in linux-next (next-20120108).
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  drivers/misc/mei/interface.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This patch no longer applies to my tree, can you please redo it against
> the latest char-misc.next branch?
>

I have sent an updated version (see [1]).
Looks like I sent that to Thomas and LKML.
Shall I resend it to you?

- Sedat -

[1] https://patchwork.kernel.org/patch/1952421/

> thanks,
>
> greg k-h
