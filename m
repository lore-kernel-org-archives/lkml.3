Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3COAwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:52:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13773 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3COAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:52:12 -0400
X-Spam-Score: -100.8
Message-ID: <5142709C.8080702@asianux.com>
Date: Fri, 15 Mar 2013 08:51:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [Suggestion] Latest randconfig build errors for CONFIG_MMU=no
References: <514147A0.2060002@asianux.com> <5141CFE4.2030909@arm.com>
In-Reply-To: <5141CFE4.2030909@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月14日 21:25, Jonathan Austin 写道:
> 
> You're right that at the moment that suspend code is broken for NOMMU.
> 
> However, Will Deacon has a patch to fix it in his nommu branch on
> kernel.org:
> 
> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=nommu
> 
> I'll let Will comment on how/when he might look at proposing that code
> to be merged.
> 
> Jonny

  thank you.

  :-)

-- 
Chen Gang

Asianux Corporation
