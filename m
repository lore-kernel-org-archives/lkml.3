Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3FDJ6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:58:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3FDJ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:58:09 -0400
Date: Tue, 4 Jun 2013 11:58:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH] perf: add const qualifier to perf_pmu_register's 'name'
 arg
Message-ID: <20130604095801.GM8923@twins.programming.kicks-ass.net>
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:45:48AM +0200, Mischa Jonker wrote:
> This allows us to use pdev->name for registering a PMU device.
> IMO the name is not supposed to be changed anyway.
> 

Indeed, and thanks! 

PS. WTH is a metag?
