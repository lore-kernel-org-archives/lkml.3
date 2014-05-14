Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaENPCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:02:40 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50021 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaENPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:02:37 -0400
Message-ID: <53738580.7000902@ahsoftware.de>
Date: Wed, 14 May 2014 17:02:24 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, Jon Loeliger <jdl@jdl.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca>
In-Reply-To: <20140514141914.446F7C4153D@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 16:19, schrieb Grant Likely:

> Rather than a dtb schema change, for the most common properties (irqs,
> clocks, gpios), we could extract dependencies at boot time. I don't like
> the idea of adding a separate depends-on property because it is very
> easy to get it out of sync with the actual binding data (dtc is not the
> only tool that manipulates .dtbs. Firmware will fiddle with it too).

Then that stuff has to fiddle correct. Sorry, but trying to solve all 
problems right from the beginning just leads to endless talks with no 
end and nothing will happen at all because nobody aggrees how to start.

Regards,

Alexander Holler

