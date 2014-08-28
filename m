Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936046AbaH1GGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:06:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57540 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbaH1GG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:06:29 -0400
Date: Thu, 28 Aug 2014 08:05:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Javi Merino <javi.merino@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v5 4/6] acerhdf: Use bang-bang thermal governor
Message-ID: <20140828060559.GB4852@nazgul.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1406043436-17068-1-git-send-email-peter@piie.net>
 <1406043436-17068-5-git-send-email-peter@piie.net>
 <1409125727.8085.23.camel@rzhang1-toshiba>
 <cone.1409126464.428976.2744.1000@mups>
 <1409188672.8085.26.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409188672.8085.26.camel@rzhang1-toshiba>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 09:17:52AM +0800, Zhang Rui wrote:
> No, I can not apply the whole series.
> I should take patch 3/6, and the others should goto Matthew Garrett'
> tree. Or I can take them with Matthew' Acked-by.

So put him on CC.

Matt, can you please ack those?

Btw, I've added the new maintainer too :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
