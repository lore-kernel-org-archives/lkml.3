Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbbALLKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:10:22 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55660 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbbALLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:10:20 -0500
Message-ID: <1421061017.22660.41.camel@x220>
Subject: Re: [PATCH v2 0/3] power: rt5033: Add Richtek RT533 drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, lee.jones@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com
Date: Mon, 12 Jan 2015 12:10:17 +0100
In-Reply-To: <54B3A72A.8020700@samsung.com>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
	 <1421059225.22660.33.camel@x220> <54B3A72A.8020700@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 11:10:18.0168 (UTC) FILETIME=[592A2B80:01D02E58]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Beomho,

On Mon, 2015-01-12 at 19:51 +0900, Beomho Seo wrote:
> On 01/12/2015 07:40 PM, Paul Bolle wrote:
> > When is the Kconfig symbol MFD_RT5033 expected to be included in the
> > tree? 
> 
> MFD_RT5033 have been applied in 09 Dec 2014.
> http://marc.info/?l=linux-pm&m=141822463218774&w=2
> According to the mail, That is expected to include next version.

I see. I'd expected v3.20 stuff to be included in linux-next by now, but
I guess that this commit will be added in a few weeks or so.

Thanks.


Paul Bolle

PS Even in the patch you dropped the "s" from Lee's address. Perhaps you
should edit it in your addressbook.

