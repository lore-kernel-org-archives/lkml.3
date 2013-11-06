Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3KFB1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:27:33 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64164 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3KFB1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:27:32 -0500
Date: Tue, 5 Nov 2013 17:27:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luigi Semenzato <semenzato@google.com>
cc: Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>, rusty@rustcorp.com.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
In-Reply-To: <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org> <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com> <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Luigi Semenzato wrote:

> It's not enough to hold a reference to the task struct, because it can
> still be taken out of the circular list of threads.  The RCU
> assumptions don't hold in that case.
> 

Could you please post a proper bug report that isolates this at the cause?

Thanks.
