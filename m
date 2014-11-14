Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161642AbaKNSq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:46:27 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42634 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161333AbaKNSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:46:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141114150411.GB3815@sirena.org.uk>
References: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
	<20141113173631.GI3815@sirena.org.uk>
	<20141114150411.GB3815@sirena.org.uk>
Date: Fri, 14 Nov 2014 10:46:22 -0800
X-Google-Sender-Auth: 9Bm_ob0DbQBblEJDRJ0aiHboViA
Message-ID: <CAL1qeaFM5wLMtGBmHnwwKeq7ps1RzL_QMRoUbAbF9iSTJMEXBg@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] spi: IMG SPFI driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 7:04 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Nov 13, 2014 at 05:36:31PM +0000, Mark Brown wrote:
>> On Wed, Nov 12, 2014 at 07:08:14PM -0800, Andrew Bresticker wrote:
>> > This series adds support for the Sychronous Peripheral Flash Interface
>> > master found on IMG SoCs.  The controller supports up to 5 chip-select
>> > lines and single, dual, and optionally quad, mode transfers.
>
>> Applied both, thanks.
>
> ...and reverted since they fail to build in x86 allmodconfig (due to a
> missing linux/interrupt.h it seems).  Please check and resend.

Sorry about that :(.  v3 incoming...
