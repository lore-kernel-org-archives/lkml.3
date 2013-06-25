Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3FYJaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:30:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3FYJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:30:13 -0400
Message-ID: <51C96322.9000801@suse.cz>
Date: Tue, 25 Jun 2013 11:30:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 25
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au> <CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com> <201306251121.53862.yann.morin.1998@free.fr> <CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
In-Reply-To: <CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.6.2013 11:26, Sedat Dilek wrote:
> On Tue, Jun 25, 2013 at 11:21 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a11650e11093ed57dca78bf16e7836517c599098
> 
>>   - for tristate choices, it is possible to select zero, one or more of the
>>     symbols in the choice
>>   - if no symbol is selected (randomly or otherwise) in a tristate choice,
>>     then the choice symbol itself has no assigned 'value'
>>   - then silentoldconfig whines
> 
> Bad bad bad Yann, didn't Marek told you to test always with...
> 
>     $ yes "" | make oldconfig; make silentoldconfig </dev/null
> 
> Anyway, have fun.

You only hit this if you have CONFIG_RAPIDIO=y in the original config.

Michal
