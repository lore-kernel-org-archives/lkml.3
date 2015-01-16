Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbbAPTHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:07:49 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42795 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbbAPTHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:07:47 -0500
Date: Fri, 16 Jan 2015 11:07:43 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jia He <hejianet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: lustre: libcfs: fix sparse warnings about
 static  declaration
Message-ID: <20150116190743.GA9827@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jia He <hejianet@gmail.com>, linux-kernel@vger.kernel.org,
	Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20150114063518.GA18644@hudson.localdomain>
 <1421398692-21827-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421398692-21827-1-git-send-email-hejianet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jia He,

Your patch is looking better :-)
A few nits though.

On Fri, Jan 16, 2015 at 04:58:12PM +0800, Jia He wrote:
>   These functions kportal_memhog_{alloc,free} aren't used outside of 
^^^^^ Don't indent paragraphs, just use a line between paragraphs.
> this file, so making them static to suppress the sparse warnings about 
> static declaration.

>   Besides, this also fixes the space warning checked by checkpatch.pl
"Besides" doesn't sound right here.  I would just say something like
"Also fix the space warning ..."

In your subject line it is helpful to add a version number so people
can tell that this is a new revision.  For example: [PATCH v2].
git format-patch can add this automatically with the '-v' option.

[...]

-- 
- Jeremiah Mahler
