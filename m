Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3A3RoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:44:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37014 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3A3RoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:44:06 -0500
Date: Wed, 30 Jan 2013 18:44:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130130174402.GB23980@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20130129202848.GE25415@pd.tnic>
 <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
 <20130130034204.GB30965@pd.tnic>
 <CAErSpo47BvEsDC1o_kYDeyd6j3VUoWHwSMYPyLpZYB1H-sL=7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo47BvEsDC1o_kYDeyd6j3VUoWHwSMYPyLpZYB1H-sL=7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:27:42AM -0700, Bjorn Helgaas wrote:
> You're right, I don't think we're quite ready to merge those patches.
> But if your NMI is easy to reproduce, it might be worth removing
> e1000e altogether to see if it still happens.

That's the problem - I've seen it only once so far. I'll watch out for
it and do the above when I find a reliable way of reproducing it. Will
keep you posted.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
