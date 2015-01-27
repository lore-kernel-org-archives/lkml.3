Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbbA0WN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:13:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44943 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759543AbbA0WN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:13:28 -0500
Date: Tue, 27 Jan 2015 22:13:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] inotify: update documentation to reflect code
 changes
Message-ID: <20150127221325.GA29656@ZenIV.linux.org.uk>
References: <1418785193-31576-1-git-send-email-zhenzhang.zhang@huawei.com>
 <54C78879.3010603@huawei.com>
 <201501270812.47160.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501270812.47160.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 08:12:47AM -0500, Gene Heskett wrote:

> As a heavy user of the inotify kit of utils, inotify_wait in particular, I 
> object if this removal breaks those tools.

What's inotify_wait?  I know of userland piece of garbage called inotifywait
(sans underscore); if that's what you had in mind, rest easy - it's not
broken any more than anything idiotify-related had always been.  It never
worked on any number of filesystems and it never will, etc., but those are
inherent limitation of that piece of crap concept, not something that had
been changed lately.
