Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaE3Hvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:51:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52676 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaE3Hvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:51:38 -0400
Message-ID: <1401436256.13544.7.camel@iivanov-dev>
Subject: Re: [PATCH v2 4/4] ARM: debug: qcom: add UART addresses to Kconfig
 help
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Georgi Djakov <gdjakov@mm-sol.com>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, sboyd@codeaurora.org,
        rvaswani@codeaurora.org, davidb@codeaurora.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Date: Fri, 30 May 2014 10:50:56 +0300
In-Reply-To: <CABuKBeLHOKK+DsVPBGPDmeSqceSTMGZeOd74-Jp4Z9vUWDZ_yQ@mail.gmail.com>
References: <1400857952-6963-1-git-send-email-gdjakov@mm-sol.com>
	 <1400857952-6963-5-git-send-email-gdjakov@mm-sol.com>
	 <CABuKBe+B_Ga-w4aA4dApDTa26rCuhetRTJku27Madm+fHtDcLA@mail.gmail.com>
	 <53834578.9090305@mm-sol.com>
	 <CABuKBeJXqSi=6XY5Fg7mg_daQ4D8ornS-kn7NDPktCtro7yNNw@mail.gmail.com>
	 <53847FA1.60509@mm-sol.com>
	 <CABuKBeLHOKK+DsVPBGPDmeSqceSTMGZeOd74-Jp4Z9vUWDZ_yQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 17:26 +0200, Matthias Brugger wrote:

> IMHO the dependancy is that DEBUG_LL uses the uart device, and this is
> added when you add the dts.
> AFAIK there can arise problems with multi-platform kernels if the uart
> is not present.

Once DEBUG_LL is enabled you don't have multi-platform kernel anymore,
so this should not be an issue here.

Regards,
Ivan

