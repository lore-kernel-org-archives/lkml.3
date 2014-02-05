Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaBEO6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:58:05 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54661 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752035AbaBEO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:58:03 -0500
Date: Wed, 5 Feb 2014 14:57:24 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Morris <jmorris@namei.org>
Cc: Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "open list:SECURITY SUBSYSTEM" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: select correct default LSM_MMAP_MIN_ADDR on
 arm on arm64
Message-ID: <20140205145723.GK7550@arm.com>
References: <1391480133-27149-1-git-send-email-ccross@android.com>
 <20140205114832.GB7550@arm.com>
 <alpine.LRH.2.02.1402060100590.24936@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402060100590.24936@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 02:02:22PM +0000, James Morris wrote:
> On Wed, 5 Feb 2014, Catalin Marinas wrote:
> 
> > On Tue, Feb 04, 2014 at 02:15:32AM +0000, Colin Cross wrote:
> > > Binaries compiled for arm may run on arm64 if CONFIG_COMPAT is
> > > selected.  Set LSM_MMAP_MIN_ADDR to 32768 if ARM64 && COMPAT to
> > > prevent selinux failures launching 32-bit static executables that
> > > are mapped at 0x8000.
> > > 
> > > Signed-off-by: Colin Cross <ccross@android.com>
> > 
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Acked-by: James Morris <james.l.morris@oracle.com>
> 
> Probably makes sense to push this through the arm tree.

With your ack, I'm happy to take it ;)

Thanks.

-- 
Catalin
