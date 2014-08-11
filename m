Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaHKKW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:22:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42257 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaHKKWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:22:25 -0400
Date: Mon, 11 Aug 2014 12:22:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: H Peter Anvin <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
Message-ID: <20140811102245.GC4236@nazgul.tnic>
References: <20140809231911.GA4843@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140809231911.GA4843@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:19:11PM -0300, Henrique de Moraes Holschuh wrote:
> Is there a way to fix this in the kernel for the BSP?

I think you're looking at this the wrong way around. :-) The thing that
needs fixing is the SDM since some CPUs seem to accept 16-byte unaligned
microcode just fine.
