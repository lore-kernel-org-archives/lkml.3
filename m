Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3LMOCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:02:38 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40019 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3LMOCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:02:37 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1312131351140.31472@tundra.namei.org>
References: <alpine.LRH.2.02.1312131351140.31472@tundra.namei.org>
Date: Fri, 13 Dec 2013 09:02:36 -0500
X-Google-Sender-Auth: 668fz8qtBIGkKJz30eZd3Fr8_fo
Message-ID: <CA+5PVA4fcf526u=AF4TwQP3xdajV-qE5Jn6NKG2mme=YK8nvhw@mail.gmail.com>
Subject: Re: [GIT] SELinux fixes
From: Josh Boyer <jwboyer@fedoraproject.org>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 9:52 PM, James Morris <jmorris@namei.org> wrote:
> Please pull.
>
>
> The following changes since commit 54fb723cc48db2fde964fb9bb0eaaccf2cf31a9f:
>
>   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-12-12 15:46:06 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>
> Geyslan G. Bem (1):
>       selinux: fix possible memory leak
>
> James Morris (1):
>       Merge branch 'master' of git://git.infradead.org/users/pcmoore/selinux_fixes into for-linus
>
> Paul Moore (5):
>       Merge tag 'v3.12'
>       selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
>       selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
>       selinux: look for IPsec labels on both inbound and outbound packets
>       selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

Should probably figure out which path to take on this one soon:

http://thread.gmane.org/gmane.linux.kernel/1611662

A revert might be the easiest for now.

josh
