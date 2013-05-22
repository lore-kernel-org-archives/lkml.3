Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3EVBV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:21:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3EVBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130521170229.GB20464@kroah.com>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<20130521170229.GB20464@kroah.com>
Date: Wed, 22 May 2013 09:21:24 +0800
Message-ID: <CACVXFVNWVx4Qaiy+A4ONqwwbB2-A00f5r5Xuv0OaABw=s0zZVA@mail.gmail.com>
Subject: Re: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 1:02 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, May 08, 2013 at 08:56:34AM +0200, Takashi Iwai wrote:
>> Hi,
>>
>> this is a series of patches for the issue we faced in the firmware
>> loader code during debugging the problem with dell_rbu driver with
>> 3.9 kernel.
>>
>> The original problem was that the shutdown gets stuck when DELL BIOS
>> update is performed.  This turned out to be a problem in the firmware
>> loader.  Although the reason of dell_rbu driver breakage is still
>> unclear, we should fix the firmware loader side, at least, not to
>> stall during shutdown.
>
> What's the status of these?  Ming, still have objections?

I have no objections now, but Takashi need to submit v2 to fix one
mistake which may break current firmware cache.

Thanks,
--
Ming Lei
