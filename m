Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaDWMPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:15:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:64872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaDWMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:15:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC 2/3] scripts/checksyscalls.sh: Make renameat optional
Date: Wed, 23 Apr 2014 14:15:24 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1398247687-13453-1-git-send-email-james.hogan@imgtec.com> <1398247687-13453-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1398247687-13453-3-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231415.24869.arnd@arndb.de>
X-Provags-ID: V02:K0:5pINtEuHa9wqpHhDyJd/NH4CNl1ZvBHdjRV1XFKw+aV
 ysGskrzx6PyiSUqeLV8eqlTY2/223zvAdf9s0f0znhEyTqxFLU
 4ERofoh9HPtOh7F5sshqmXoou6/BIFjWqaerKRWRJuhCx61VEi
 rjIHj1KOK5CF55u1FdWLSM+yOj/2L7Z6z92Mea+bHg94YYlB0l
 Q5qARzWxd/pSE1PIniOgOzo39JuoNftFC+vc9BUmIF37bxqN1T
 lG/Wmw40O+hzQ153TcYhLfKZTWi48vh+X7BU5hC/nuCjY0ZNoh
 FJwy/Gv934ZPH1GIIPAoRJK/l7nZfxk91FtS2XnlrQcU16Q0Ne
 EEKN7AheIsziVtrJBuPs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014, James Hogan wrote:
> The new renameat2 syscall provides all the functionality of renameat
> with an additional flags argument, so make renameat optional so that
> future architectures can omit it without getting a warning.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> ---
> This patch doesn't affect existing architectures, so there's no harm for
> this to wait for the v3.16 merge window.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I'm not actually sure how we'd arrange for new architectures not
to provide renameat() when using the generic syscall ABI, but this
patch is correct anyway.

	Arnd
