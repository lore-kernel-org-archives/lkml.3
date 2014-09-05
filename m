Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaIEIwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:52:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48770 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaIEIwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:52:31 -0400
Date: Fri, 5 Sep 2014 10:52:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140905085222.GB11432@nazgul.tnic>
References: <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
 <20140903064015.GA3941@nazgul.tnic>
 <20140903124302.GA18507@khazad-dum.debian.net>
 <20140904154246.GA10884@nazgul.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A666A7F@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A666A7F@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 06:37:05PM +0000, Yu, Fenghua wrote:
> In case this comment may cause confusion, I need to confirm that:
> 
> The parameter "dis_ucode_ldr" only turns off early microcode loading from the initrd.
> It does not trun off loading microcode later during run time.

Are you asking or are you saying?

Because it should disable loading of the microcode machinery later too -
see microcode_init().

-- 
Regards/Gruss,
    Boris.
--
