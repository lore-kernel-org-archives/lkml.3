Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaCWPfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:35:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56815 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaCWPfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:35:09 -0400
Date: Sun, 23 Mar 2014 15:35:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs fixes
Message-ID: <20140323153505.GI18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
 <CA+icZUU=VzD+LM6i9VK6HuJooOj+yKHtJR+MOjaXjs68MGcRPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUU=VzD+LM6i9VK6HuJooOj+yKHtJR+MOjaXjs68MGcRPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 11:57:16AM +0100, Sedat Dilek wrote:

> Your branch on top of Linux v3.14-rc7-66-g774868c7094d is freezing my
> Ubuntu/precise AMD64 (WUBI) system when running LTP.

Which test?
