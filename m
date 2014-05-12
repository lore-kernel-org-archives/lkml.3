Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaELW63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:58:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:32878 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaELW61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:58:27 -0400
Message-ID: <537151FF.8070104@ahsoftware.de>
Date: Tue, 13 May 2014 00:58:07 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jon Loeliger <loeliger@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] dt: deps: dtc: Add option to print initialization
 order
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-4-git-send-email-holler@ahsoftware.de> <CAJgR-BhnFngGr9qxa7NvF7GExiCAr1=HS16AtN20uj7nCmLcKQ@mail.gmail.com>
In-Reply-To: <CAJgR-BhnFngGr9qxa7NvF7GExiCAr1=HS16AtN20uj7nCmLcKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.05.2014 22:38, schrieb Jon Loeliger:
> So, this should be rebased on the actual DTC repository,
> and not the kernel's copy of the DTC under scripts.

I have patches for the standalone dtc too. I just didn't want to poste
almost the same patches twice and wanted to wait for feedback if people
do like this stuff at all.

Do you already want those 3 patches for the standalone dtc?

Regards,

Alexander Holler

