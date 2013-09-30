Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3I3UDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:03:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab3I3UDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:03:17 -0400
Date: Mon, 30 Sep 2013 21:03:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Aditya Kali <adityakali@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatol Pomazau <anatol@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        tj@kernel.org, axboe@kernel.dk
Subject: Re: [RFC] vfs: avoid sb->s_umount lock while changing bind-mount
 flags
Message-ID: <20130930200313.GT13318@ZenIV.linux.org.uk>
References: <1379353350-11320-1-git-send-email-adityakali@google.com>
 <20130917024040.GH13318@ZenIV.linux.org.uk>
 <523B5AEA.1070808@google.com>
 <CAGr1F2E1Xo7Y_xb-UXt6WCyhi0Hq+ygovuAp8pAHkwTkKOV-FA@mail.gmail.com>
 <5249BF43.705@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249BF43.705@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 11:13:23AM -0700, Aditya Kali wrote:
> +Ted Ts'o, Tejun Heo, Jens Axboe
> 
> 
> On 09/30/2013 10:54 AM, Aditya Kali wrote:
> >Hi Al and other fs-developers,
> >
> >Please let me know what you think about this patch.

Don't top-post, please...  What prevents a race between MS_BIND remounts
and plain ones?  Used to be serialized on ->s_umount, but...
