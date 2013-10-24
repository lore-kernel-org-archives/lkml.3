Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3JXUq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:46:58 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:44633 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3JXUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:46:57 -0400
Date: Thu, 24 Oct 2013 17:46:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix library detection when building without libelf
Message-ID: <20131024204650.GA20423@ghostprotocols.net>
References: <1382583069-26121-1-git-send-email-patrick@parcs.ath.cx>
 <20131024201349.GG4998@ghostprotocols.net>
 <CA+C-WL9eP2p0SVF8CZi+KABvBOgHiuFKe9Znx2ioJfYLxxH0OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+C-WL9eP2p0SVF8CZi+KABvBOgHiuFKe9Znx2ioJfYLxxH0OA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 24, 2013 at 04:36:47PM -0400, Patrick Palka escreveu:
> On Thu, Oct 24, 2013 at 4:13 PM, Arnaldo Carvalho de Melo
> > The feature detection was reworked and perhaps it is fixed there.
 
> I can't reproduce the detection failure in your branch, and a quick inspection
> shows that the new feature-detection code is not subject to the kind of bug
> that my patch fixed. So consider my patch obsolete.

Thanks for checking!

- Arnaldo
