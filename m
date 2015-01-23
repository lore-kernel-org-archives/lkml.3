Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbbAWBa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:30:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52652 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbbAWBa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:30:56 -0500
Date: Fri, 23 Jan 2015 01:30:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: weird and wrong directory entries
Message-ID: <20150123013053.GY29656@ZenIV.linux.org.uk>
References: <20150123004138.GA2626@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123004138.GA2626@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:42:21AM +0900, Sergey Senozhatsky wrote:
> Hello gents,
> 
> I observe this sick behaviour for the past few days. (sorry, some lines are
> over 80 symbols). all of the things above are happening during kernel compilation.
> attached .config.

> happens both on reiserfs and ext4, both on current linus's tree and linux-next.
> no doubt, an attempt to rm -fr pkg/   kills   /usr/, etc.
> 
> 
> I'm puzzled. any thoughts?

Try to bisect, perhaps?
