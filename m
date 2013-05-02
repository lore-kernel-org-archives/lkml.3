Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3EBPK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:10:58 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:45651 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159Ab3EBPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:10:57 -0400
Date: Thu, 2 May 2013 15:10:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Huck <will.huckk@gmail.com>
cc: Han Pingtian <hanpt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <5180883F.3040003@gmail.com>
Message-ID: <0000013e65cbcdc9-9a394918-ea30-4d91-97f9-77af82fcda3b-000000@email.amazonses.com>
References: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com> <20130417094750.GB2672@localhost.localdomain> <20130417141909.GA24912@dhcp22.suse.cz> <20130418101541.GC2672@localhost.localdomain> <20130418175513.GA12581@dhcp22.suse.cz>
 <20130423131558.GH8001@dhcp22.suse.cz> <20130424044848.GI2672@localhost.localdomain> <20130424094732.GB31960@dhcp22.suse.cz> <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com> <20130425060705.GK2672@localhost.localdomain>
 <0000013e42332267-0b7fb3c0-9150-4058-8850-ae094b455b15-000000@email.amazonses.com> <517B8A5D.1030308@gmail.com> <0000013e56450fd2-c7a854d1-ff7f-47a7-a235-30721fead5e0-000000@email.amazonses.com> <5180883F.3040003@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.02-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Will Huck wrote:

> > Age refers to the mininum / avg / maximum age of the object in ticks.
>
> Why need monitor the age of the object?


Will give you some idea as to when these objects were created.


