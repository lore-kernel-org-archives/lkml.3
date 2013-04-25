Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab3DYVwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:52:02 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:57597 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab3DYVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <1366727607-27444-5-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-5-git-send-email-james.hogan@imgtec.com>
Date: Thu, 25 Apr 2013 23:52:00 +0200
Message-ID: <CACRpkda3_G3B-QYOKNSTk6jk3764RF_hAtOEiE_ep7xmRnek-Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] metag: tz1090: add <asm/soc-tz1090/gpio.h>
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add <asm/soc-tz1090/gpio.h> with definitions to number all the GPIOs
> available on-chip. This is for use by the pinctrl and GPIO drivers.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Usually the specific pins and names is a pecularity best contained
in the GPIO or pinctrl subsystem.

Please try to push this down into the driver, and only use a simple number
to access the GPIOs.

Yours,
Linus Walleij
