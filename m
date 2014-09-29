Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaI2OS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:18:58 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:59839 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238AbaI2OS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:18:57 -0400
Message-ID: <54296A4E.9050809@nexus-software.ie>
Date: Mon, 29 Sep 2014 15:18:54 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Dave Jones <davej@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Quark: Enable correct cache size/type reporting
References: <1411956372-16469-1-git-send-email-pure.logic@nexus-software.ie> <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie> <20140929134008.GA7764@redhat.com> <542968AE.3090407@nexus-software.ie> <20140929141727.GA19294@gmail.com>
In-Reply-To: <20140929141727.GA19294@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 15:17, Ingo Molnar wrote:
>> My feeling is that we'll probably end up with less changes/new code taking
>> the approach of quirking.
>
> OTOH, if the Quark quirk is a .legacy_cache_size callback, it
> will be compiled out on 64-bit kernels. With your patch it's
> unconditional.
>
> So Dave's suggestion makes sense.

OK.

Let's make the change.

--
BOD
