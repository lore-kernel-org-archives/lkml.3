Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbbAWCGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:06:50 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51895 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbbAWCGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:06:48 -0500
Date: Fri, 23 Jan 2015 11:06:44 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: weird and wrong directory entries
Message-ID: <20150123020644.GA466@swordfish>
References: <20150123004138.GA2626@swordfish>
 <20150123013053.GY29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123013053.GY29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/23/15 01:30), Al Viro wrote:
> On Fri, Jan 23, 2015 at 09:42:21AM +0900, Sergey Senozhatsky wrote:
> > Hello gents,
> > 
> > I observe this sick behaviour for the past few days. (sorry, some lines are
> > over 80 symbols). all of the things above are happening during kernel compilation.
> > attached .config.
> 
> > happens both on reiserfs and ext4, both on current linus's tree and linux-next.
> > no doubt, an attempt to rm -fr pkg/   kills   /usr/, etc.
> > 
> > 
> > I'm puzzled. any thoughts?
> 
> Try to bisect, perhaps?
> 

ok, I'll try to.

	-ss
