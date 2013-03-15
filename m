Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3COKgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:36:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56392 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3COKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:36:45 -0400
X-Spam-Score: -100.8
Message-ID: <5142F99E.6030607@asianux.com>
Date: Fri, 15 Mar 2013 18:36:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrea Adami <andrea.adami@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, matthew.leach@arm.com,
        dave.martin@linaro.org, nico@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
References: <51415428.1070401@asianux.com> <20130314234323.GD4977@n2100.arm.linux.org.uk> <514270D2.9010205@asianux.com> <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com>
In-Reply-To: <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月15日 17:31, Andrea Adami 写道:
> AFAIK Arnd is aware and waiting for feedback about his patch:
> 
> ARM: compressed/head.S: work around new binutils warning   Arnd Bergmann
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/144846.html

  excuse me, I am not familiar with arm assemble code, so can not give more information

  but at least for me, it seems your patch is more precious, and also welcomed by compiler.
  and I don't think your patch make the code "a more complex":
    the reason is:
    "keeping code simple and clear" is for readers and debuggers, not for writers.
    I prefer to write more code to let readers and debuggers easy understand.
      (if it has minor negative effect with performance)

  thanks.

-- 
Chen Gang

Asianux Corporation
