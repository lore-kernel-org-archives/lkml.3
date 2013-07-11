Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3GKNTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:19:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37844 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3GKNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:19:03 -0400
Date: Thu, 11 Jul 2013 15:18:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
Message-ID: <20130711131845.GB8900@pd.tnic>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
 <20130711104307.GB28131@pd.tnic>
 <CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
 <20130711123548.GA8900@pd.tnic>
 <CAF2Nc0ybnoQ7ZYoYzZNci4PaPnH5PA8--8-OBw4u0b3COT6tDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF2Nc0ybnoQ7ZYoYzZNci4PaPnH5PA8--8-OBw4u0b3COT6tDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:56:46PM +0200, Konrad Vrba wrote:
> .config is attached

Your config builds just fine here.

And you must be having some garbage lying around because 3.10 doesn't
have timeconst.pl:

$ git describe
v3.10
$ git ls-files | grep timeconst
kernel/timeconst.bc

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
