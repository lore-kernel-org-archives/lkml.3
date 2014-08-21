Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaHUTTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:19:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58676 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaHUTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:19:17 -0400
Message-ID: <53F64624.5000403@ahsoftware.de>
Date: Thu, 21 Aug 2014 21:19:00 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com>
In-Reply-To: <20140821140211.GD19293@ulmo.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.08.2014 16:02, schrieb Thierry Reding:

> Anyway, those are all fairly standard reasons for where deferred probe
> triggers, and since I do like deferred probe for it's simplicity and
> reliability I'd rather not try to work around it if boot time is all
> that people are concerned about.

It's neither simple nor reliable. It's non deterministic brutforcing 
while making it almost impossible to identify real errors.

In my humble opinion the worst way to solve something. I'm pretty sure 
if I would have suggest such a solution, the maintainer crowd would have 
eaten me without cooking.

Regards,

Alexander Holler

