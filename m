Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaGJLDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:03:17 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50048 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaGJLDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:03:16 -0400
Message-ID: <1404990194.19776.5.camel@x220>
Subject: Re: [PATCH] Kbuild: Move -Wmaybe-uninitialized to W=1
From: Paul Bolle <pebolle@tiscali.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        x86-ml <x86@kernel.org>
Date: Thu, 10 Jul 2014 13:03:14 +0200
In-Reply-To: <20140710104223.GD2970@pd.tnic>
References: <20140616132045.GE8170@pd.tnic>
	 <20140616211405.GA7914@ravnborg.org> <20140624213835.GD15068@pd.tnic>
	 <20140707105339.GA4776@pd.tnic> <1404811520.26126.38.camel@x220>
	 <20140708113724.GA27659@pd.tnic> <20140710104223.GD2970@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jul 2014 11:03:14.0518 (UTC) FILETIME=[8BD0CF60:01CF9C2E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 12:42 +0200, Borislav Petkov wrote:
> I haven't even wished for it but just to prove everybody my point: just
> built rc4+ from Linus' repo with gcc 4.9.0, see below.
> 
> Now all of a sudden there's more noise, maybe because this is a
> different .config. However, I doubt those are real bugs.

Would you mind sharing that .config?

> A cursory look through those shows that they're not really bugs -
> gcc simply can't know with all the ifdeffery, partial usage based on

Nit: I'd expect ifdeffery to make the code only difficult to understand
for the human reader. By the time gcc will be doing flow analysis the
preprocessor has long handled all ifdeffery.

> conditionals, etc, etc.

Thanks,


Paul Bolle

