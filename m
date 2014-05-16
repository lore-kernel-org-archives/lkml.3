Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbaEPKMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:12:33 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60535 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaEPKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:12:31 -0400
Date: Fri, 16 May 2014 12:12:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geoff Levand <geoff@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] vmlinux.lds.h: Add new SECTION() macro
Message-ID: <20140516101204.GA10187@ravnborg.org>
References: <1400189158.11178.157.camel@smoke>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400189158.11178.157.camel@smoke>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:25:58PM -0700, Geoff Levand wrote:
> Add a new preprocessor macro SECTION() to vmlinux.lds.h that defines a
> linker script output section with the section attributes commonly used,
> and replace all occurrences of equivalent descriptions in vmlinux.lds.h
> with the new macro.

Looks good - but the name is too generic.
Use OUTPUT_SECTION() as you suggest in the comment below.

If you walk through all linker scripts then keep an eay out for
stuff where the generic stuff can be used.
And see if there is something else that really belongs in asm-generic.

	Sam

