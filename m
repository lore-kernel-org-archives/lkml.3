Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaLCBKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:10:45 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36647 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaLCBKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141203004852.GA15236@kroah.com>
References: <1417533075-687-1-git-send-email-paul@mybb.com>
	<20141203004852.GA15236@kroah.com>
Date: Tue, 2 Dec 2014 19:10:41 -0600
Message-ID: <CAO7UptcspiZCNi8smcmhOWM9Rdn+QYHPJYmZb90A-_3sJ4wYqQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: ft1000: fix spaces around comparisons in ft1000_debug.c
From: Paul H <paul@mybboard.net>
To: Greg KH <greg@kroah.com>
Cc: Paul H <paul@mybb.com>, Belisko Marek <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tutorial I read suggested using a different branch for applying the
patches; I named it "fix-spaces".  It would appear it is mistaken
then?

Thanks again, hope I'm not bothering at all, first time trying to give back.

-Paul

On Tue, Dec 2, 2014 at 6:48 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 02, 2014 at 09:11:15AM -0600, Paul Hedman wrote:
>> This fix fixes spacing issues around operators, e.g. i=0 to i = 0, found by the checkpatch.pl tool.
>
> Please wrap your changelog at the correct column.
>
>>
>> Signed-off-by: Paul Hedman <paul@mybb.com>
>> ---
>>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
>>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> This doesn't apply to my tree at all :(
>



-- 
-Paul H.
MyBB Support Team
