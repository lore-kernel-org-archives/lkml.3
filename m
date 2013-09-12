Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3ILWAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:00:21 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:65321 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130912215650.GQ13318@ZenIV.linux.org.uk>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
	<CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
	<52320FA3.7000908@hp.com>
	<CA+55aFyvC=vKWn2-PBrfyFB9gS08DBUNwXvHhO6KaoLz=SJbMw@mail.gmail.com>
	<20130912215650.GQ13318@ZenIV.linux.org.uk>
Date: Thu, 12 Sep 2013 15:00:18 -0700
X-Google-Sender-Auth: Hv8ScqcGItrSKepC4fL7b1MLaXU
Message-ID: <CA+55aFzdVf5veU4UMZ8tiThJauatroV5ZvQ0dtg6Y6jZnv5ZDg@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 2:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Sep 12, 2013 at 12:04:56PM -0700, Linus Torvalds wrote:
>>
>> Btw, Al, I really want a pull request from you to fix the "returning
>> to user space with semaphore held" thing. Or I'm going to apply the
>> patch myself.  I'm on the road starting very early tomorrow morning,
>> and I don't want to have that hanging over me..
>
> Well...  The pull request contains quite a bit more than that - list_lru
> pile, mostly.

Ok, I'm going to really hope this is it for 3.12, because while I will
have my laptop, I will spend Friday traveling, the weekend diving,
before the week of LinuxCon.

So if you were planning a "pile 4", I hope we can leave it for 3.13.

            Linus
