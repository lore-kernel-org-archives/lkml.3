Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaK2JPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:15:20 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53839 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaK2JPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:15:17 -0500
Date: Sat, 29 Nov 2014 01:15:10 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] linux-next: 20141127 boot hang
Message-ID: <20141129091510.GA1366@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org
References: <20141127231619.GA1713@hudson.localdomain>
 <20141128233250.GA4921@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128233250.GA4921@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all,

On Fri, Nov 28, 2014 at 03:32:50PM -0800, Jeremiah Mahler wrote:
> On Thu, Nov 27, 2014 at 03:16:19PM -0800, Jeremiah Mahler wrote:
> > 
> > I just tried the latest linux-next 20141127 (commit 3bcf494d225fd19) and
> > it hangs very early in the boot sequence, after decompressing the kernel
> > and after fsck (see attached screen shot).  I have tried it with two
> > different machines and they both have the same problem.  It worked with
> > version 20141126.
> > 
> []
> 
> My bisect results so far indicate that the bug was introduced by this
> merge commit.
> 
>   commit 0305904a7416ced1358c5ff575e58135453bfc1d
>   Merge: 38a4751 2ef5864
>   Author: Stephen Rothwell <sfr@canb.auug.org.au>
>   Date:   Thu Nov 27 14:53:44 2014 +1100
>   
>       Merge remote-tracking branch 'block/for-next'
>       
>       Conflicts:
>           fs/fs-writeback.c
> 
[]

Something is definitely broken at this merge commit.  I haven't
quite figured out how to bisect the patches inside the merge commit.
Any suggestions are welcome.

-- 
- Jeremiah Mahler
