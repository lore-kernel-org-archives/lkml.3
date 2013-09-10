Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3IJBQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:16:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35567 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3IJBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130910005754.GV13318@ZenIV.linux.org.uk>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk> <20130910004020.29299.qmail@science.horizon.com>
 <20130910005754.GV13318@ZenIV.linux.org.uk>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 10 Sep 2013 06:45:38 +0530
Message-ID: <CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>, john@stoffel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> _What_ "pathname translations"?  Pathname resolution doesn't fall back to
> seq_writelock() at all.

Maybe it should then?
