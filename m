Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbaH0SOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:14:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50158 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbaH0SOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:14:19 -0400
Message-ID: <53FE1FE9.6070109@ahsoftware.de>
Date: Wed, 27 Aug 2014 20:14:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826101107.GC32315@leverpostej> <20140827103432.64927C409CB@trevor.secretlab.ca> <20140827144403.GB13850@arm.com> <53FE05AE.9000406@wwwdotorg.org> <53FE07BE.7000809@ahsoftware.de> <53FE0966.5020206@wwwdotorg.org> <20140827175243.GJ13850@arm.com>
In-Reply-To: <20140827175243.GJ13850@arm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.08.2014 19:52, schrieb Catalin Marinas:

>> Irrespective though, a new kernel needs to work against an old DT,
>
> I fully agree. But we shouldn't really extend the "old DT" statement to
> a new ARMv8 SoC ;).

Or any new v7 SoC. And even poor users of current ARM HW do want use 
their HW. And they don't care if they have to change the DT if they 
finally are able to use their board, which happens seldom enough. (I'm 
not speaking about companies which are able to spend many man-years to 
fix one kernel version for use with one specific HW).

Regards,

Alexander Holler
