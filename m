Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936133AbaH1GvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:51:12 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50582 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbaH1GvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:51:09 -0400
Message-ID: <53FED13C.4070606@ahsoftware.de>
Date: Thu, 28 Aug 2014 08:50:36 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Mark Rutland <Mark.Rutland@arm.com>,
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
References: <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826101107.GC32315@leverpostej> <20140827103432.64927C409CB@trevor.secretlab.ca> <20140827144403.GB13850@arm.com> <53FE05AE.9000406@wwwdotorg.org> <53FE07BE.7000809@ahsoftware.de> <53FE0966.5020206@wwwdotorg.org>
In-Reply-To: <53FE0966.5020206@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.08.2014 18:37, schrieb Stephen Warren:

> Of course, there are probably cases where we could/should add some more
> phandles/... and likewise cases where we shouldn't. That's why detailed
> research is needed.

Just because I'm curious, I wonder how this research does or shoud look 
like.

Defered probes did come to light with 3.4, that was more than 2 years 
ago. Ok, most people (like me) just noticed it during the last months 
when they switched to DT and have run into a problem (the deferred probe 
mechanism is an error-message killer), but some must have seen it 
already 2 years ago.

And I wonder how the ACPI world solves that problem. My guess would be 
hardcoded stuff in the firmware-blob (BIOS), just like it happened with 
board files, but I've never seen BIOS code and my knowledge about ACPI 
is almost zero. ;)

Regards,

Alexander Holler
