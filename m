Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936407Ab3DHVsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:48:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32844 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935961Ab3DHVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:48:36 -0400
Date: Mon, 8 Apr 2013 22:48:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: hangs on boot in 9984d7394618df9
Message-ID: <20130408214834.GV4068@ZenIV.linux.org.uk>
References: <515DB465.1060004@sgi.com>
 <20130404204459.GU21522@ZenIV.linux.org.uk>
 <515F0456.9040803@sgi.com>
 <20130405173623.GE4068@ZenIV.linux.org.uk>
 <515F3A71.9080008@sgi.com>
 <20130405210042.GH4068@ZenIV.linux.org.uk>
 <5162E36F.5020305@sgi.com>
 <20130408155847.GS4068@ZenIV.linux.org.uk>
 <51632DF8.2080402@sgi.com>
 <20130408212327.GU4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408212327.GU4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:23:27PM +0100, Al Viro wrote:
> On Mon, Apr 08, 2013 at 03:52:08PM -0500, Nathan Zimmer wrote:
> 
> > Further digging seems to indicate 9984d7394618df9, the one right
> > after the commit I previously identified.
> > Not sure what I did wrong with my bisect to put it off by one.
> 
> Ugh...  Can't reproduce here ;-/  Could you give more details on your
> setup?

Anyway, I've just pushed a splitup of that commit (carved in 3 pieces)
into vfs.git#pipe-splitup; could you check which part triggers that
hang?  Should propagate in a few...
