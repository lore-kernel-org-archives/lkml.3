Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3JOTYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:24:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45031 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab3JOTYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:24:06 -0400
Date: Tue, 15 Oct 2013 21:23:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@gmail.com>, Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: Extended H/W error log driver
Message-ID: <20131015192353.GI7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
 <20131014064940.GD12189@gchen.bj.intel.com>
 <20131014105533.GF4009@pd.tnic>
 <20131015040731.GA887@gchen.bj.intel.com>
 <20131015092851.GA7908@pd.tnic>
 <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com>
 <20131015191040.GA4347@naverao1-tp.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015191040.GA4347@naverao1-tp.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:40:40AM +0530, Naveen N. Rao wrote:
> +2 ;)

You're counting for 2 people, huh?

:-)

> While at it, I wonder if we're better off calling these "Hardware
> events" rather than "Hardware errors".

Oh, please no. That's that euphemistic lying which serves no one. And
here's what I mean by "euphemistic lying":

https://www.youtube.com/watch?v=vuEQixrBKCc

Let's call it what it really is but, at the same time, make sure it is
understandable to users what action they need to undertake (or none)
when they encounter it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
