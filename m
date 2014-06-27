Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaF0JJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:09:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60535 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0JJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        rric@kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [Linaro-acpi] [PATCH v4 12/13] ARM64 / ACPI: if we chose to boot from acpi then disable FDT
Date: Fri, 27 Jun 2014 11:09:27 +0200
Message-ID: <5766378.doqChWUeyl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403840976-7456-13-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org> <1403840976-7456-13-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fOYfEuEjSCILyNp3YhVVCQUJcuGVB7hOoipLggR51jY
 bLuh/0lnzZ4WNMRLLWWZtMP+Y5pHnpKu27M5brPe8Dd04H7Yk4
 DOhtohFnjXEyYlT6XY5m3JaLSvxSe3A8FezqFiL7CIWZxRwJFU
 ZMCjDO5HYdEfMvcGGdkqkV46gwzblcIQkjLt78aZ1aCg0JPLj3
 yHxW9BFOmHFJogp2P5p6WzlDe5uPJAvDmRffMF926e4nTPoyaS
 4wmTLyvVhtNhWE4GKoZA/gvJF1sslhnMAj2lW/OhM1tO+mDm6K
 4Xwn6j3xLRpQ33QCx6KppkGE8v5ISZiBd+OUw4n+7DPQEmcweR
 hdO2rat2nx3V+3ieFbVk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014 11:49:35 Hanjun Guo wrote:
> From: Graeme Gregory <graeme.gregory@linaro.org>
> 
> If the early boot methods of acpi are happy that we have valid ACPI
> tables and acpi=off has not been passed. Then do not unflat devicetree
> effectively disabling further hardware probing from DT.
> 

I guess this answers the question I had on patch 4 ;-)

	Arnd
