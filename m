Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbaDJMYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:24:00 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:38459 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279AbaDJMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140410122146.GY6518@sirena.org.uk>
References: <1397132030-2440-1-git-send-email-harinik@xilinx.com>
	<20140410122146.GY6518@sirena.org.uk>
Date: Thu, 10 Apr 2014 17:53:56 +0530
Message-ID: <CAFcVECLRaz2tQwCP0t5v8y-T9Qz+DRao0sH80ceKCqaqPBdqLA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] SPI: Add driver for Cadence SPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Apr 10, 2014 at 5:51 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 10, 2014 at 05:43:49PM +0530, Harini Katakam wrote:
>
>> Firstly, the timeout value obtained from this is a too low.
>> This timeout is typically used for an error conditions such as
>> hardware hang etc. and using a value >1*HZ would be better.
>> This driver used to use similar timeout and as I understand, other
>> drivers also use similar values.
>
> Send patches...

Ok thanks, I will.

Regards,
Harini
