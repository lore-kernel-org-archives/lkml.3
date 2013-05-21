Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3EUN6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:58:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48968 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3EUN6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:58:49 -0400
Date: Tue, 21 May 2013 15:58:44 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130521135844.GB1860@rric.localhost>
References: <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
 <20130517092741.GR19669@dyad.programming.kicks-ass.net>
 <20130517094551.GE23035@pd.tnic>
 <20130517103600.GG8356@rric.localhost>
 <20130517105730.GD5162@dyad.programming.kicks-ass.net>
 <20130521085630.GA1860@rric.localhost>
 <20130521110537.GG26912@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521110537.GG26912@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.13 13:05:37, Peter Zijlstra wrote:
> Reported-by: Josh Boyer <jwboyer@redhat.com>
> Acked-by: Robert Richter <rric@kernel.org>

Fine with me.

> -static int setup_event_constraints(void)
> +__init int amd_core_pmu_init(void)

Just noticed this should be static int __init.

Thanks,

-Robert
