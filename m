Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaCYVcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:32:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57226 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaCYVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:32:32 -0400
Date: Tue, 25 Mar 2014 16:32:26 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andre Tomt <andre@tomt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, Eric Paris <eparis@redhat.com>
Subject: Re: Linux 3.14-rc8 (LXC broken)
Message-ID: <20140325213226.GC14857@sergelap>
References: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
 <5331E8CB.3060708@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5331E8CB.3060708@tomt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andre Tomt (andre@tomt.net):
> *testing hat on*
> 
> PAM within namespaces (say, LXC) does not work anymore with 3.14-rc8,
> making login, ssh etc fail in containers unless you boot with audit=0.
> 
> This is due to a change in return value to user space; and is
> appearantly a known issue as evident in this earlier post from february:
> https://www.redhat.com/archives/linux-audit/2014-February/msg00087.html
> 
> Judging from the post it seems they want to ship 3.14 with this IMO
> quite serious regression? What is the namespace/container folks take on
> this?

Without looking too deeply, it seems to me that patch has no
benefit on its own, and should simply be stashed until the next
set of patches are ready.

-serge
