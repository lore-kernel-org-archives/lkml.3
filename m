Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab3EVL1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:27:42 -0400
Received: from mx10.gouders.net ([89.244.147.155]:46160 "EHLO mx10.gouders.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab3EVL1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:27:42 -0400
Authentication-Results: mx10.gouders.net; dkim=none reason="no signature";
	dkim-adsp=discard
From: Dirk Gouders <dirk@gouders.net>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
In-Reply-To: <20130522111850.GA15091@pd.tnic> (Borislav Petkov's message of
	"Wed, 22 May 2013 13:18:50 +0200")
References: <giy5b7uyfe.fsf@karga.hank.lab> <20130522111850.GA15091@pd.tnic>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 22 May 2013 13:27:29 +0200
Message-ID: <gimwrnuue6.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@suse.de> writes:

> Hi,
>
> On Wed, May 22, 2013 at 12:00:21PM +0200, Dirk Gouders wrote:
>> CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6
>> -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
>> $(EXTRA_CFLAGS) -fPIC
>
> it seems someone else hit this already and fixed it too:
>
> commit d2f32479e5526a1ab3b4e43910fcb279871524ce
> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date:   Sun Feb 17 16:03:36 2013 +0100
>
>     perf tools: check if -DFORTIFY_SOURCE=2 is allowed

Yes, I should have checked the whole log and not just for one file. 
And please ignore my other mail which I sent just when yours arrived ;-)

Dirk
