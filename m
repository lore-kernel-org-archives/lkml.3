Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126Ab3FSVwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:52:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53768 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934566Ab3FSVwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:52:42 -0400
Date: Wed, 19 Jun 2013 23:52:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130619215233.GU28300@pd.tnic>
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
 <20130618140730.GA1313@redhat.com>
 <20130618155919.GC13123@pd.tnic>
 <51C225D9.8070100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C225D9.8070100@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:42:49PM -0700, H. Peter Anvin wrote:
> There is serious confusion with regards to DR6 about the bits which
> are *fixed* (forced to 1) and the ones which are *reserved* (should
> always have a fixed value.)
>
> There are some bits in DR6 which are used by hardware probes.

Haha, I knew it! HW guys don't care about the architectural documents.

Maybe DR6 should probably be dropped altogether from the check before
exiting __show_regs early?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
