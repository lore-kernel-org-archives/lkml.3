Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015AbaFTJ3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:29:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:33415 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964927AbaFTJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:28:59 -0400
Date: Fri, 20 Jun 2014 10:28:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EFI urgent fix
Message-ID: <20140620092848.GC23939@arm.com>
References: <20140620090008.GU24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620090008.GU24049@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:00:08AM +0100, Matt Fleming wrote:
> Please pull the following compiler warning fix. Sorry, I've been pretty
> slow in getting this pull request sent. Multiple people have reported
> hitting it and I've now received 4 patches for the same warning,

BTW, one of them is not just a simple warning but a bug. Pointer to
"long" variable on the stack passed to a function that only takes a
pointer to "int". We are probably lucky that we don't hit the bug on
arm64.

Anyway, thanks for pushing the fix.

(and lesson learnt not to trust the ARM EFI_STUB developers, won't name
them, with properly testing their code ;))

-- 
Catalin
