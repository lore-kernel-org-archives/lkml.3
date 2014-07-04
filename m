Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaGDOvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:51:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaGDOva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:51:30 -0400
Date: Fri, 4 Jul 2014 16:51:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        dhowells@redhat.com, pjones@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/9] kexec: Verify signature of PE signed bzImage
Message-ID: <20140704145118.GD3340@pd.tnic>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 05:07:12PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This patch series enables signature verification of signed PE bzimage. This
> patches series needs two more patch series before it.
> 
> First one is kexec_file_load() syscall support posted here.
> 
> https://lkml.org/lkml/2014/6/26/497
> 
> This patch seris is also available in -mm tree now.
> 
> Second one is PKCS7 signature parsing and verification support. These
> patches are available in David Howells's modsign tree in pkcs7 branch.
> 
> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pkcs7
> 
> This patch series is based on David Howells's work of PE file parsing
> and PKCS7 signature verificaiton. Now PKCS7 signature part is available
> in his tree. So I have taken PE file parsing patches, changed them a
> bit and posting these here.

Ok, now this looks strange. You're referring to those patches without
posting them together with yours. And they're in some repo. Normally in
such cases people post the *whole* patchset and do not refer to some
other tree.

>From looking at them, they're part of the pull request which Linus did
shot down already last year:

https://lkml.org/lkml/2013/2/21/228

And he explicitly stated then that we don't want PE file parsing in the
kernel, AFAICR. What changed since then?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
