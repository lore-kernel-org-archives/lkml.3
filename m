Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3GCNzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3GCNzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:55:35 -0400
Message-ID: <51D42D53.3000800@suse.cz>
Date: Wed, 03 Jul 2013 15:55:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: strnape1@fel.cvut.cz
Cc: Nicolas Palix <nicolas.palix@imag.fr>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] scripts: Coccinelle script for pci_free_consistent()
References: <20130508230308.Horde.hkDwg5wWGGBzmzKnqIjUhg1@wimap.feld.cvut.cz> <CAAxaTiPTtNTpo8DAE628=En=sa0hTzeOJ19DoxE9GwdiQnrUqg@mail.gmail.com>
In-Reply-To: <CAAxaTiPTtNTpo8DAE628=En=sa0hTzeOJ19DoxE9GwdiQnrUqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.6.2013 15:03, Nicolas Palix wrote:
> On Wed, May 8, 2013 at 11:03 PM,  <strnape1@fel.cvut.cz> wrote:
>> Created coccinelle script for reporting missing pci_free_consistent() calls.
>>
>> Signed-off-by: Petr Strnad <strnape1@fel.cvut.cz>
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

Applied to kbuild.git#misc. BTW, the patch was malformed at several
places, you mailer broke long lines like this:

>> +msg = "ERROR: missing pci_free_consistent; pci_alloc_consistent on line %s
>> and return without freeing on line %s" % (p1[0].line,p2[0].line)

Please send the patch to yourself next time and verify that 'git am' can
apply it, before sending it to the mailing list.

Thanks,
Michal
