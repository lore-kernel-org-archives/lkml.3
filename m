Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaIZRkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:40:15 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:47955 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbaIZRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:40:14 -0400
Message-ID: <5425A4FC.9070706@nexus-software.ie>
Date: Fri, 26 Sep 2014 18:40:12 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, hpa@zytor.org, mingo@redhat.com,
        tglx@linutronix.de, hmh@hmh.eng.br, boon.leong.ong@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Add if/else to setup_arch for Quark TLB bug
References: <1411751985-4351-1-git-send-email-pure.logic@nexus-software.ie> <20140926173546.GA9931@redhat.com>
In-Reply-To: <20140926173546.GA9931@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 18:35, Dave Jones wrote:
>   > +	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
>   > +		__flush_tlb();
>
> This also needs a check for the cpu vendor, or this will apply
> the workaround on for eg, AMD K6-III's.

Ah OK.

Will update.

--
BOD

