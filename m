Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3GOGW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:22:28 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53390 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3GOGW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <51E392CE.9000605@kernel.org>
References: <alpine.LFD.2.03.1307142205090.2124@kernel.org>
	<CA+55aFytd8NZeX1ux8U56uQk65N3jcq_7UMv1RrFgAPmLJc-dw@mail.gmail.com>
	<51E392CE.9000605@kernel.org>
Date: Mon, 15 Jul 2013 09:22:26 +0300
X-Google-Sender-Auth: wqcAtGFU1DTDXWizjItYHRpDIMc
Message-ID: <CAOJsxLE5ThzRtfm9kr3xTG=Gc5Kwe1U46ovEBh0f+5j+SRUDhQ@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.11-rc0
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 9:12 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> Ugh. I'll merge the commits leading up to that, but not the actual
>> broken try at unification at all.
>>
>> There's just one one-liner patch in between the broken commits and
>> their reverts, I don't see the point of pulling that part at all, and
>> I can take the one-liner separately.
>
> OK, I'll requeue the oneliner commit. Thanks!

Oh, you picked it up yourself. Thanks Linus!

                        Pekka
