Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaBEN6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:58:07 -0500
Received: from tundra.namei.org ([65.99.196.166]:49703 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaBEN6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:58:04 -0500
Date: Thu, 6 Feb 2014 01:02:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "open list:SECURITY SUBSYSTEM" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: select correct default LSM_MMAP_MIN_ADDR on
 arm on arm64
In-Reply-To: <20140205114832.GB7550@arm.com>
Message-ID: <alpine.LRH.2.02.1402060100590.24936@tundra.namei.org>
References: <1391480133-27149-1-git-send-email-ccross@android.com> <20140205114832.GB7550@arm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Catalin Marinas wrote:

> On Tue, Feb 04, 2014 at 02:15:32AM +0000, Colin Cross wrote:
> > Binaries compiled for arm may run on arm64 if CONFIG_COMPAT is
> > selected.  Set LSM_MMAP_MIN_ADDR to 32768 if ARM64 && COMPAT to
> > prevent selinux failures launching 32-bit static executables that
> > are mapped at 0x8000.
> > 
> > Signed-off-by: Colin Cross <ccross@android.com>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: James Morris <james.l.morris@oracle.com>

Probably makes sense to push this through the arm tree.


-- 
James Morris
<jmorris@namei.org>
