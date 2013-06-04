Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3FDNnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab3FDNnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:43:40 -0400
Date: Tue, 4 Jun 2013 15:45:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [09/65] math64: New div64_u64_rem helper
Message-ID: <20130604134508.GB17229@redhat.com>
References: <20130603221016.243553628@goodmis.org>
 <20130603221153.655422077@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603221153.655422077@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 06:10:25PM -0400, Steven Rostedt wrote:
> 3.6.11.5 stable review patch.
> If anyone has any objections, please let me know.

If you will not pull other commits (I do not see them in the set):

d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
55eaa7c1f511af5fb6ef808b5328804f4d4e5243
772c808a252594692972773f6ee41c289b8e0b2a
f3002134158092178be81339ec5a22ff80e6c308
68aa8efcd1ab961e4684ef5af32f72a6ec1911deA

this one is not necessary and actually hit performance a bit.

Stanislaw

