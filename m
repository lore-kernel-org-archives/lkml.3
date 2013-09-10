Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3IJCdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:33:12 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55029 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3IJCdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130910022505.GW13318@ZenIV.linux.org.uk>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk>
	<20130910004020.29299.qmail@science.horizon.com>
	<20130910005754.GV13318@ZenIV.linux.org.uk>
	<CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
	<CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
	<20130910022505.GW13318@ZenIV.linux.org.uk>
Date: Mon, 9 Sep 2013 19:33:09 -0700
X-Google-Sender-Auth: FvETWRChnEO-4qfS0BP49-V_hfM
Message-ID: <CA+55aFyP4K-0nrAUtM+a8v54+MCZwz6Ve_wopnET7thT5HKggA@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        John Stoffel <john@stoffel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 7:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> One name: Mark V. Shaney...

Heh, yes. I had ignored the earlier emails, and that last one looked
more reasonable than the earlier ones ;)

               Linus
