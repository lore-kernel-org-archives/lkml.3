Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaLQCqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:46:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49256 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLQCqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:46:08 -0500
Date: Wed, 17 Dec 2014 02:46:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: nick <xerofoify@gmail.com>
Cc: akpm@linux-foundation.org, fabf@skynet.be, tytso@mit.edu,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: Remove cramfs source code from mainline kernel?
Message-ID: <20141217024602.GG22149@ZenIV.linux.org.uk>
References: <5490E6F8.4030207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5490E6F8.4030207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 09:14:16PM -0500, nick wrote:
> Greetings Andrew and others,
> I am wondering as cramfs as been marked obsolete for a while why haven't it been removed? If one of the maintainers can explain why that would be greatly be appreciated. Otherwise I am recommending if there are no good reasons we should remove cramfs from main line as it seems to be only used on systems before squashfs was made main line and well supported  from my knowledge.
> Cheers,
> Nick :)  

a) learn to use line breaks
b) what do we win from removing it?  If it starts becoming inconvenient to
maintain, it might make sense to consider removal, but as it is...  What,
somebody has slapped a couple of F-words in there?  "FIXME", that is...

Al, seriously tempted to add

/* FIXME.  FIXME.  FIXME.  DO NOT remove that comment - it serves
a very important purpose by tormenting a certain fetishist */

on top of a bunch of files in fs/*.c, just to see what effect will it have...
