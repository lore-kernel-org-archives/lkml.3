Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBZPhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:37:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51604 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaBZPhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:37:15 -0500
Date: Wed, 26 Feb 2014 16:37:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140226153709.GE22639@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
 <20140221145910.GE11531@pd.tnic>
 <20140224164131.GJ4631@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140224164131.GJ4631@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:41:31AM -0500, Vivek Goyal wrote:
> Right now there is only one user. But once other image loader support
> comes along or other arches support file based kexec, they can make
> use of same function.
> 
> This is a pretty important modification as it decides what's the starting
> point of next kernel image. I wanted to make it a function callable by
> users who wanted to modify it instead of of letting them directly 
> modify image->start.

But are you expecting any other way to set image->start by the other
arches/image loaders?

> Could be. I am trying to reuse exisitng code. In current code, user space
> passes a list of segments and then kernel calls this function to make sure
> all the segments passed in make sense.
> 
> Here also arch dependent part of kernel is preparing a list of segments
> wanted and then generic code is reusing the existing function to make
> sure segment list is sane. I like code reuse part of it.

Right, ok, this was just an idea. Maybe not worth it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
