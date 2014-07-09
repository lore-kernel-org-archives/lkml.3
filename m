Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaGILN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbaGILNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:13:25 -0400
Date: Wed, 9 Jul 2014 13:13:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140709111307.GA1814@krava.redhat.com>
References: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 08:03:39PM +0400, Stanislav Fomichev wrote:
> This patchset adds IO mode: instead of process time we record io syscalls
> and then draw timechart of writes/reads/tx/rx/polls.
> 
> v6:
>   - v5 didn't actually contained 'converted consistency checks' fix, so
>     respinning the series once again with the fix folded;
>     Namhyung, can I still keep your Acked-By?
>     Jiri, can you please pull it?

yep, I'm on it

jirka
