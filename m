Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaK0GH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:07:58 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44017 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaK0GH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:07:57 -0500
Message-ID: <5476BFB4.2020705@hitachi.com>
Date: Thu, 27 Nov 2014 15:07:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com>
In-Reply-To: <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/27 3:59), Steve Capper wrote:
> The crash is extremely easy to reproduce.
> 
> I've not observed any missed events on a kprobe on an arm64 system
> that's still alive.
> My (limited!) understanding is that this suggests there could be a
> problem with how missed events from a recursive call to memcpy are
> being handled.

I think so too. BTW, could you bisect that? :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


