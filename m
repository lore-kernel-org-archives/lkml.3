Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaGNNk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:40:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbaGNNkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:40:51 -0400
Message-ID: <53C3DDBB.2000304@redhat.com>
Date: Mon, 14 Jul 2014 15:40:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Liang, Kan" <kan.liang@intel.com>, Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com> <53C3C517.4000500@redhat.com> <20140714120922.GV9918@twins.programming.kicks-ass.net> <53C3CFC1.9070800@redhat.com> <37D7C6CF3E00A74B8858931C1DB2F077014E1A91@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014E1A91@SHSMSX103.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/07/2014 15:36, Liang, Kan ha scritto:
>> > Kan Liang, what happens if CONFIG_PARAVIRT=y?  Do you get garbage or
>> > just no events reported?
>> >
> Guest rdmsr/wrmsr will eventually call rdmsr_safe/wrmsr_safe. They will handle the #GP. So there is no error report in guest.

Yeah, but what's the effect on the output of perf?

Paolo

