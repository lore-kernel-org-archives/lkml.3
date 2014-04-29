Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaD2P1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:27:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44093 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758047AbaD2P1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:27:17 -0400
Date: Tue, 29 Apr 2014 16:27:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
Message-ID: <20140429152707.GM26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <20140429102817.GE17007@arm.com>
 <20140429114356.GK26088@console-pimps.org>
 <20140429134726.GH17007@arm.com>
 <20140429144713.GL26088@console-pimps.org>
 <535FBD94.9040101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FBD94.9040101@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr, at 07:56:20AM, H. Peter Anvin wrote:
> 
> I'm wondering if it would be better to organize it into a separate topic
> branch.  We can still take it through tip, if you want, but it would be
> better than putting it all into one tree.

Sure, that makes sense. I'll do that.

-- 
Matt Fleming, Intel Open Source Technology Center
