Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3BKNJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:09:16 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:50833 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab3BKNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:09:13 -0500
Message-ID: <5118ED6A.3050809@synopsys.com>
Date: Mon, 11 Feb 2013 18:38:58 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal
 handling)
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-9-git-send-email-vgupta@synopsys.com> <51189D2F.4030000@synopsys.com> <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com> <5118C458.2070205@synopsys.com> <5118C7B6.6040807@imgtec.com> <CACM3HyG+4Pzx02iL9atxG+FOLiCcTeXR+ivzRO78bqDHNp5rGQ@mail.gmail.com> <5118D478.3010205@synopsys.com> <CACM3HyG7B=iMb4cHYP2cb8np55t8WefWTh4x3SYkGK4Lc=RXbA@mail.gmail.com> <5118E60E.5060606@synopsys.com> <CACM3HyF8VhGo9zaAFiX8z97nz-fLeyCSZOCwAN=py5NfxhCfGw@mail.gmail.com>
In-Reply-To: <CACM3HyF8VhGo9zaAFiX8z97nz-fLeyCSZOCwAN=py5NfxhCfGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 06:32 PM, Jonas Bonn wrote:
> On 11 February 2013 13:37, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> Anyhow going back to my orig patch - if we park the
>> callee-regs-in-sigcontext-or-not, other bits look OK ?
>>
> Aside from the callee-regs question (which I hope somebody more
> knowledgeable can chime in on):  Acked-by: Jonas Bonn
> <jonas@southpole.se>

Thx. As I mentioned, this patch will needed to be chopped and squashed into
several existing commits.
I presume I'll add the Ack to "ARC: Fundamental ARCH data-types/defines" which
contains the initial def of ptrace.h

-Vineet


