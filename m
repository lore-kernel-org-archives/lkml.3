Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbbAUKGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:06:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50500 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbbAUKGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:06:37 -0500
Date: Wed, 21 Jan 2015 11:06:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Dave Young <dyoung@redhat.com>, linux-efi <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
Message-ID: <20150121100633.GC12173@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <20141210021741.GA3280@darkstar.nay.redhat.com>
 <20141210104627.GA17053@pd.tnic>
 <20150105140332.GB3163@console-pimps.org>
 <54AAA723.1070605@redhat.com>
 <54BF3DCA.4070708@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54BF3DCA.4070708@jonmasters.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:48:58AM -0500, Jon Masters wrote:
> We have on a number of occasions found just this output useful in
> debugging boot issues on ARM servers

We can turn it on by default on ARM and off on x86...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
