Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab3GaPbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:31:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58134 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3GaPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:31:18 -0400
Date: Wed, 31 Jul 2013 17:31:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
Message-ID: <20130731153115.GA5233@pd.tnic>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com>
 <87zjte9iah.fsf@rustcorp.com.au>
 <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:39:23PM +0300, Mike Rapoport wrote:
> There are plenty virtual machines in EC2, Rackspace, HP and other
> clouds that do not have hardware virtualization. I believe that
> running a hypervisor on them may be pretty interesting.

Interesting how?

How interesting is it really to run nested on a public
surveillance^Wcloud platform vs say, using nested kvm on your own
machine?

What are those very important use cases which warrant growing more of
that pvops gunk^Wcreativity?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
