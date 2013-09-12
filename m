Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3ILDkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:40:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49209 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab3ILDkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:40:15 -0400
X-Sasl-enc: cQZpOFcgThbexb+xtzM+w3fxtUF+ZhFUhnAtQSUcpzOu 1378957214
Date: Wed, 11 Sep 2013 20:40:23 -0700
From: Greg KH <greg@kroah.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, hpa@zytor.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 00/16] [RFC PATCH] Signed kexec support
Message-ID: <20130912034023.GA10877@kroah.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:44:15PM -0400, Vivek Goyal wrote:
> Hi,
> 
> Matthew has been posting patches to lock down kernel either due to
> secureboot requirements or because of signed modules with signing
> enforced. In kernel lock down mode, kexec will be disabled and that
> means kdump will not work either.
> 
> These patches sign /sbin/kexec and kernel verifies the signature
> and allows loading a kernel if signature verification is successful.
> IOW, trust is extended to validly signed user space.
> 
> Currently it works only for statically linked applications.

That's a really big restriction, pretty much making it not workable for
distros at the moment to use.

Any chance to change this in the future?  Or just rely on the existing
"signed binaries" functionality we have in the kernel today for the
kexec binary as well?  Wouldn't that be simpler?

thanks,

greg k-h
