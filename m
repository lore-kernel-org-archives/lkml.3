Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKQKnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:43:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaKQKnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:43:17 -0500
Message-ID: <5469D142.9090500@suse.de>
Date: Mon, 17 Nov 2014 11:43:14 +0100
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ankit Jindal <ankit.jindal@linaro.org>, linux-kernel@vger.kernel.org
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH v5 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
References: <1416220572-13381-1-git-send-email-ankit.jindal@linaro.org> <1416220572-13381-6-git-send-email-ankit.jindal@linaro.org>
In-Reply-To: <1416220572-13381-6-git-send-email-ankit.jindal@linaro.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.11.2014 um 11:36 schrieb Ankit Jindal:
> This patch adds device tree binding documentation for
> X-Gene QMTM UIO driver.
> 
> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
> ---
>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   50 ++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt

FWIW,

Reviewed-by: Andreas Färber <afaerber@suse.de>

Thanks,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
