Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3FDLKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:10:41 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:45328 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3FDLKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:10:38 -0400
Message-ID: <51ADCAD1.8090900@synopsys.com>
Date: Tue, 4 Jun 2013 16:39:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: add const qualifier to perf_pmu_register's 'name'
 arg
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com> <20130604095801.GM8923@twins.programming.kicks-ass.net> <51ADBB1D.9060805@synopsys.com> <20130604110314.GN8923@twins.programming.kicks-ass.net>
In-Reply-To: <20130604110314.GN8923@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 04:33 PM, Peter Zijlstra wrote:
> Simlar 'complaint' for the ARC stuff really, only marketing speak :-) 

You mean lack of prefix in this case (as opposed to MetaG).

Anyhow, this patch served a lot more purpose than Mischa really wanted - formally
introduced you to two new architectures ;-)

-Vineet

