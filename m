Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBYXGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:06:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaBYXGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:06:30 -0500
Message-ID: <530D21BA.8030108@zytor.com>
Date: Tue, 25 Feb 2014 15:05:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "msalter@redhat.com" <msalter@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
References: <1392238575-10000-1-git-send-email-msalter@redhat.com> <1393337404.7307.51.camel@deneb.redhat.com> <20140225183012.GA27164@mudshark.cambridge.arm.com> <1393353942.26583.10.camel@deneb.redhat.com> <530CF21E.1020603@zytor.com> <5D4B48CE-46BA-44E8-BCDE-AEACAC9973AF@arm.com>
In-Reply-To: <5D4B48CE-46BA-44E8-BCDE-AEACAC9973AF@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:04 PM, Catalin Marinas wrote:
> 
> I think the series still need an ack from rmk at least on the arm patch
> (4/6).
> 

OK.  Russell?

	-hpa


