Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaESNRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaESNRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:17:30 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change rtw_alloc_stainfo23a to use gfp_t instead if int
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
	<20140519101855.GU15585@mwanda>
	<wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
	<20140519104012.GP16255@mwanda>
	<wrfjlhtyrqlc.fsf@ultrasam.lan.trained-monkey.org>
	<20140519114000.GW15585@mwanda>
Date: Mon, 19 May 2014 15:10:29 +0200
In-Reply-To: <20140519114000.GW15585@mwanda> (Dan Carpenter's message of "Mon,
	19 May 2014 14:40:00 +0300")
Message-ID: <wrfj8upxsym2.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Mon, May 19, 2014 at 12:49:03PM +0200, Jes Sorensen wrote:
>> You should be running your tools against the staging tree automatically,
>> that way you catch it before it hits the mainline tree.
>>
>> Just flooding mailing lists for the sake of flooding them doesn't add
>> any value either.
>
> We are used to handling the traffic.  Heh.  Don't worry about us.  ;)

I know how the traffic works, and I know I don't particularly like
flooding that I don't need to receive. I'll add
devel@driverdev.osuosl.org to the CC list next time.

> I don't actually run static analysis on staging patches until they hit
> linux-next, I only review the mailing list patches manually.  My review
> process is built around mailing lists so creating a special process for
> rtl8723au makes my life harder instead of easier.  Every subsystem has a
> review process, it's not that we are treating you unfairly by asking you
> to send your patches for review.

I am not suggesting you do it for the rtl8723au driver, I suggest you do
it as a general thing. I don't read devel@driverdev.osuosl.org either,
and like many other developers, I mostly gave up on lkml as well.

> Btw, Greg doesn't rebase the staging tree so, once a patch is merged,
> then it means it will hit mainline.  At that point, it is too late to
> send a second version of the patch.

I know, but I also know that I am not going to rebase my tree and
resubmit the full set, unless there is a strong reason for doing so.
As long as something sits in staging it's not really a showstopper if a
minor issue slips past and gets fixed up in a follow-on commit.

Jes
