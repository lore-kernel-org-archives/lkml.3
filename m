Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaKNGUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:20:54 -0500
Received: from ozlabs.org ([103.22.144.67]:39170 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaKNGUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:20:52 -0500
Message-ID: <1415946050.26378.3.camel@concordia>
Subject: Re: powerpc: Fix Text randomization
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vineeth Vijayan <vvijayan@mvista.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Nov 2014 17:20:50 +1100
In-Reply-To: <CAOpNGcsQX1d4=MpHKKKnBotBb11dq55_kQp4PG8OA++U6peqKg@mail.gmail.com>
References: <1412919926-13123-1-git-send-email-vvijayan@mvista.com>
	 <20141015020811.7904E14011B@ozlabs.org>
	 <CAOpNGcsgX0wVOgMN77+RuKVsb_iHQ7XQk8U_05-up__wC6zuZQ@mail.gmail.com>
	 <CAOpNGcsQX1d4=MpHKKKnBotBb11dq55_kQp4PG8OA++U6peqKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 11:03 +0530, Vineeth Vijayan wrote:
> ping !
> 
> any update on this ? As i understand, only powerpc and s390 uses the
> randomize_et_dyn call; for all other architecture this is an obsolete
> function call.

I asked:

> >> I'm not clear on what has changed to break this?

And you didn't tell me.

> this call for another patch where randomize_et_dyn is removed.

Patches welcome :)

cheers


