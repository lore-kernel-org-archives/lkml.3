Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3KGJiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab3KGJis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:38:48 -0500
Date: Thu, 7 Nov 2013 10:38:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 0/4] perf record: Cleanups and mmap-based output
Message-ID: <20131107093837.GA1251@krava.brq.redhat.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:41:33AM -0700, David Ahern wrote:
> I know Jiri is working on cleanups of the output file, but had this
> sitting around for a couple of weeks now. Might as well push it out
> for the next baseline. The cleanups of perf-record can be taken
> independently.

np, I'll rebase once your change is in

jirka
