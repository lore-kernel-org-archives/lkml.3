Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaIYQ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:57:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45686 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaIYQ5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:57:46 -0400
Date: Thu, 25 Sep 2014 18:57:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925165740.GE28201@nazgul.tnic>
References: <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
 <20140925144025.GA14030@khazad-dum.debian.net>
 <20140925145655.GA28201@nazgul.tnic>
 <20140925153006.GB10814@khazad-dum.debian.net>
 <20140925155044.GB28201@nazgul.tnic>
 <20140925164121.GC10814@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140925164121.GC10814@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 01:41:21PM -0300, Henrique de Moraes Holschuh wrote:
> We still need to update x86_capability after a microcode update for the
> above to really work in the "install microcode into initramfs" case.

I think you mean for the kernels without early microcode loading...

Because those which do early loading will have loaded the microcode much
earlier than the x86_capability bits are detected. AFAICS, of course. It
is late already :-\

-- 
Regards/Gruss,
    Boris.
--
