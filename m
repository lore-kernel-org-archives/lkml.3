Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IJCZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:25:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55424 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJCZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:25:14 -0400
Date: Tue, 10 Sep 2013 03:25:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        George Spelvin <linux@horizon.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        John Stoffel <john@stoffel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130910022505.GW13318@ZenIV.linux.org.uk>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk>
 <20130910004020.29299.qmail@science.horizon.com>
 <20130910005754.GV13318@ZenIV.linux.org.uk>
 <CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
 <CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:34:16PM -0700, Linus Torvalds wrote:
> On Mon, Sep 9, 2013 at 6:15 PM, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> >
> > Maybe it should then?
> 
> It doesn't need to. The RCU lookup looks at individual dentry sequence
> numbers and doesn't care about the bigger rename sequence number at
> all.

One name: Mark V. Shaney...
