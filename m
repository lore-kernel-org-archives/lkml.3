Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3FGIxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:53:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38279 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3FGIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:52:39 -0400
Date: Fri, 7 Jun 2013 09:49:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        linux-arm-kernel@lists.infradead.org, debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
	Uploading linux (3.9.4-1))
Message-ID: <20130607084913.GR18614@n2100.arm.linux.org.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <1370475609.20454.44.camel@localhost> <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com> <1733666.lHUBcfUXq9@flatron> <CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com> <20130606131042.GN18614@n2100.arm.linux.org.uk> <CAPweEDyYt+pN+UaFuqWL5RrHpyuq_4So-tArmx3dr=0wLS+hwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDyYt+pN+UaFuqWL5RrHpyuq_4So-tArmx3dr=0wLS+hwQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 09:02:43AM +0100, luke.leighton wrote:
>  ok.  so.  we come back to the question again: what shall i propose to
> them that they consider doing, and what benefit would it be to them to
> do so?
> 
>  i cannot go to them and say "you have to do this [insert proposal
> here]" - it has to be more subtle than that.

It seems that you don't have to do anything at all.  From what Arnd and
others have said, they are _already_ talking to, and working with people
in the kernel community to move their code base forward, move to DT, and
they are already starting to send their own patches for the mainline
kernel themselves.
