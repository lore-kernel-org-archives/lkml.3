Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaCXML6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaCXML5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:11:57 -0400
From: Paul Moore <pmoore@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: empty commit in the security tree
Date: Mon, 24 Mar 2014 08:11:50 -0400
Message-ID: <2288468.3EeUVpQZvb@sifl>
Organization: Red Hat
User-Agent: KMail/4.12.3 (Linux/3.12.13-gentoo; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140321092541.77ae84b831cc71b1318d6f12@canb.auug.org.au>
References: <20140321092541.77ae84b831cc71b1318d6f12@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 21, 2014 09:25:41 AM Stephen Rothwell wrote:
> Hi James,
> 
> I noticed this commit in the security tree this morning:
> 
> commit 2c5f5c9a1d1b3559cbbda8e014706eb359566c00
> Author: Paul Moore <pmoore@redhat.com>
> Date:   Wed Mar 19 16:46:04 2014 -0400
> 
>     selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
> 
> It has no changes, just a commit message.  Did something go missing?

If I remember correctly James merged this patch into his security tree after I 
had applied it to the SELinux tree but before the SELinux tree was pulled into 
the security tree.  There was also some "differences in process" (see the LSM 
archives if you're interested) when it came to pulling the SELinux tree into 
the security tree, the end result is what you are seeing now.  The differences 
should be fixed going forward as James' has agreed to start merging regular 
releases (e.g. 3.14, 3.15, 3.16, ...) into the security tree so this shouldn't 
happen again.

The good news for this particular patch is that it *is* applied to the 
security tree, this duplicate/empty entry can be ignored.  I'm sorry for the 
confusion.

-Paul

-- 
paul moore
security and virtualization @ redhat

