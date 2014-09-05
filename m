Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaIENkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:40:47 -0400
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:41812 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbaIENkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140905094747.GE30401@n2100.arm.linux.org.uk>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
	<1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
	<20140905094747.GE30401@n2100.arm.linux.org.uk>
Date: Fri, 5 Sep 2014 15:40:44 +0200
Message-ID: <CAE0=X_1CZkSjmde4o1707scjJtdzZdXokaS--3VjEuE4XTac-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
From: Anders Berg <anders.berg@avagotech.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 11:47 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 01, 2014 at 02:53:40PM +0200, Anders Berg wrote:
>> The AXM55xx device has a ARM PL022 SSP controller with an extension that
>> enables the control of up to five chip select signals. This driver implements
>> the logic to control these signals and exports them as GPIOs.
>>
>> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
>
> So, what happens if the GPIO driver binds first, followed by the SSP
> device?  Please test that scenario out before this patch gets merged.
>

Both scenarios work.
/Anders
