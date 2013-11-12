Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3KLEg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:36:59 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:36453 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3KLEgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:36:51 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH v3 1/2] ARC: Add perf support for ARC700 cores
Thread-Topic: [PATCH v3 1/2] ARC: Add perf support for ARC700 cores
Thread-Index: AQHO28D/wkaNy+MR2Ei7jLd6xxrTzw==
Date: Tue, 12 Nov 2013 04:36:45 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075155E99@IN01WEMBXA.internal.synopsys.com>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
 <1383832512-21130-2-git-send-email-mjonker@synopsys.com>
 <20131111162715.GB26898@twins.programming.kicks-ass.net>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 09:57 PM, Peter Zijlstra wrote:
> On Thu, Nov 07, 2013 at 02:55:11PM +0100, Mischa Jonker wrote:
>> This adds basic perf support for ARC700 cores. Most PERF_COUNT_HW* events
>> are supported now.
> I don't see anything particularly weird, but then I don't know/have the
> hardware so I suppose you know what you're doing :-)
>
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Thanks Peter.

This is now queued for next batch for arc 3.13-rc1 changes since we've been using
this internally for quite some time now.

-Vineet
