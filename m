Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3ISSrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:47:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60133 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab3ISSrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:47:01 -0400
Date: Thu, 19 Sep 2013 20:46:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130919184656.GF9412@pd.tnic>
References: <20130919145834.GA4298@khazad-dum.debian.net>
 <20130919164409.GA9427@pd.tnic>
 <20130919181554.GA10055@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130919181554.GA10055@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 03:15:54PM -0300, Henrique de Moraes Holschuh wrote:
> I can request help on debian-user or debian-devel to get someone with
> an AMD box to help with bissection, but it is usually best if we don't
> ask general users to bissect kernels (due to non-zero risk of data
> corruption if the bissect hit one of the problem spots that often show
> up during the development window).

I have a couple of AMD boxes so I can bisect - I just need a reproducer
how to trigger.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
