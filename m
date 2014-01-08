Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaAHMFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:05:37 -0500
Received: from r00tworld.com ([212.85.137.150]:36809 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbaAHMFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:05:35 -0500
From: "PaX Team" <pageexec@freemail.hu>
To: x86@kernel.org
Date: Wed, 08 Jan 2014 13:04:51 +0100
MIME-Version: 1.0
Subject: Re: [llvmlinux] [PATCH 4/4] x86, boot: Work around clang PR18415.
Reply-to: pageexec@freemail.hu
CC: llvmlinux@lists.linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <52CD3EE3.6295.92E23548@pageexec.freemail.hu>
In-reply-to: <1389180083-23249-4-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>, <1389180083-23249-4-git-send-email-David.Woodhouse@intel.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jan 2014 13:04:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jan 2014 at 11:21, David Woodhouse wrote:

> Clang's intrinsics ignore -mregparm=3 when they fall back to calling the
> out-of-line implementations. Putting the args on the stack when memcpy()
> expects them in registers is not a recipe for a happy kernel.
> 
> This bites with -m32 too, so clang is presumably catastrophically
> broken for the i386 kernel until this is fixed, unless I'm missing
> something.

llvmlinux already carries my old patch (and some more) here:
 arch/i586/patches/0026-Add-own-versions-of-memcpy-and-memset-for-compilatio.patch

(see also my comment on the clang PR)

cheers,
 PaX Team

