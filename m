Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaCYUmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:42:31 -0400
Received: from mail1.ugh.no ([178.79.162.34]:53510 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbaCYUm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:42:28 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 16:42:28 EDT
Message-ID: <5331E8CB.3060708@tomt.net>
Date: Tue, 25 Mar 2014 21:36:27 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, Eric Paris <eparis@redhat.com>
Subject: Re: Linux 3.14-rc8 (LXC broken)
References: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
In-Reply-To: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*testing hat on*

PAM within namespaces (say, LXC) does not work anymore with 3.14-rc8,
making login, ssh etc fail in containers unless you boot with audit=0.

This is due to a change in return value to user space; and is
appearantly a known issue as evident in this earlier post from february:
https://www.redhat.com/archives/linux-audit/2014-February/msg00087.html

Judging from the post it seems they want to ship 3.14 with this IMO
quite serious regression? What is the namespace/container folks take on
this?
