Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaI2WcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbaI2WcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:32:07 -0400
Date: Tue, 30 Sep 2014 00:28:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
	perf_event_free_task()
Message-ID: <20140929222855.GA15796@redhat.com>
References: <20140926210652.GA27199@erable> <20140927180725.GA15594@redhat.com> <20140929101201.GE5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929101201.GE5430@worktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Peter Zijlstra wrote:
>
> Something like so then?

Yes, thanks, I believ this is correct.

Oleg.

