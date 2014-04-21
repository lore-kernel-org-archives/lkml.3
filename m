Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaDUQ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:29:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47137 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaDUQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:29:07 -0400
Date: Mon, 21 Apr 2014 17:29:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [RFC 1/2] fs,proc: Pass nameidata to proc_get_link
 implementations
Message-ID: <20140421162903.GR18016@ZenIV.linux.org.uk>
References: <cover.1398097304.git.luto@amacapital.net>
 <79198263e1989bf0916e3aa51a253d8b4c08a396.1398097304.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79198263e1989bf0916e3aa51a253d8b4c08a396.1398097304.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:22:47AM -0700, Andy Lutomirski wrote:
> proc_fd_link should respect fs modes, and it needs to know the open
> mode to do so.

So pass it by value.  NAK in that form.
