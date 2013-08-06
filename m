Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3HFOHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab3HFOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:07:20 -0400
Date: Tue, 6 Aug 2013 15:59:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 2/2] perf tests: Add tests of new pinned modifier
Message-ID: <20130806135958.GC1068@krava.brq.redhat.com>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
 <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:28:06PM +1000, Michael Ellerman wrote:
> Add a negative test to test__checkevent_pmu_events() to get lots of
> coverage of the negative case, ie. when the modifier is not specified.
> 
> Add a test of a single event, and of the group case.

nice! :)

jirka
