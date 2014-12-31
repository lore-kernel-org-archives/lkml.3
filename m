Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaLaTeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:34:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57271 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaLaTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:34:10 -0500
Date: Wed, 31 Dec 2014 20:28:42 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, gdonald@gmail.com,
        tapaswenipathak@gmail.com, yejiayily@gmail.com,
        mcgrof@do-not-panic.com, anarey@gmail.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, joe@perches.com
Subject: Re: [PATCH 1/4] staging: rtl8192u: fix comments
Message-ID: <20141231192842.GC25819@t400>
References: <1420051376-31180-1-git-send-email-lstoakes@gmail.com>
 <20141231190044.GB25819@t400>
 <CAA5enKaHPBWvmQfDEkdG5T-ZMgq-qCD1arCDvUTBK4bQSmqTNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA5enKaHPBWvmQfDEkdG5T-ZMgq-qCD1arCDvUTBK4bQSmqTNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31, Lorenzo Stoakes wrote:
> On 31 December 2014 at 19:00, Konrad Zapalowicz <bergo.torino@gmail.com> wrote:
> >
> > You also fix the line length here which shall be the subject of a
> > separate patch as this is not C99 comments related change.
> >
> 
> Apologies - I missed this, will prepare a v2 with this separated out
> into a different patch. Relatedly, the intent was to fix whitespace
> issues rather than line length as I gather a specific line length
> limit is still a matter of debate in kernel style? I didn't want to

Usually the kernel people like the line length of 80 characters. There
are exceptions like for example for log messages because it makes easier
to search for it however most of the time 80 is good and whenever
possible it shall be applied.

You can read about it in the
https://www.kernel.org/doc/Documentation/CodingStyle document in second
chapter.

cheers,
konrad

> create additional noise by attempting to address that as well.
> 
> Best, Lorenzo
