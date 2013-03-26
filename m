Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3CZAJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:09:17 -0400
Received: from tundra.namei.org ([65.99.196.166]:37633 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977Ab3CZAJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:09:14 -0400
Date: Tue, 26 Mar 2013 11:09:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Nicolas Schichan <nschichan@freebox.fr>
cc: Will Drewry <wad@chromium.org>, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seccomp: allow BPF_XOR based ALU instructions.
In-Reply-To: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
Message-ID: <alpine.LRH.2.02.1303261109290.24539@tundra.namei.org>
References: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Nicolas Schichan wrote:

> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>  kernel/seccomp.c |    2 ++
>  1 file changed, 2 insertions(+)

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
