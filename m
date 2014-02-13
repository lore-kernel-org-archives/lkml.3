Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBMQYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:24:23 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:43187 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBMQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:24:21 -0500
Date: Thu, 13 Feb 2014 17:25:34 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <19258.1392306854@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19258.1392306854@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:54:14PM +0000, David Howells wrote:
> 
> If we're going to be adding a new rename inode op, can we make it take a flag
> to white out the source for union type things?  This would mean that
> rename-and-white-out can be done atomically.

That is an option, yes.

Regarding whiteouts, I raised a couple of questions that nobody answered yet, so
let me ask again.

- If a filesystem containing whiteouts (fallthroughs, etc...) is mounted as not
part of a union, how are these special entities represented to userspace?

- Can the user remove them?

Thanks,
Miklos

