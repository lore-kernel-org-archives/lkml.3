Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaBOVdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:33:06 -0500
Received: from asavdk4.altibox.net ([109.247.116.15]:45408 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBOVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:33:04 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 16:33:04 EST
Date: Sat, 15 Feb 2014 22:32:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/19] Kbuild, lto: add ld-version and ld-ifversion macros
Message-ID: <20140215213259.GA27587@ravnborg.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <1392412903-25733-11-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412903-25733-11-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:21:34PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> To check the linker version. Used by the LTO makefile.

Everything in Kbuild.include is supposed to be documented in Documentation/kbuild/*
Please add documentation too.

	Sam
