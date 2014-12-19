Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaLSIBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:01:22 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:57908 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaLSIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:01:20 -0500
Message-ID: <1418976092.27549.4.camel@mm-sol.com>
Subject: Re: [PATCH 0/4] Support qcom GDSC hardware
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mike Turquette <mturquette@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Wagantall <mattw@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 19 Dec 2014 10:01:32 +0200
In-Reply-To: <534D72E5.1000805@codeaurora.org>
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
	 <534D72E5.1000805@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1.2~trusty 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-04-15 at 10:56 -0700, Stephen Boyd wrote:
> On 04/04/14 11:45, Stephen Boyd wrote:
> > These patches add support for the multimedia GDSCs on the
> > apq8074 dragonboard. The first two patches (and potentially the last)
> > should go through Mike's tree and the DTS patch should go through
> > the qcom tree. Patches are based on v3.14. The probe will conflict with
> > patches I sent to consolidate things. I'll rework these patches on top of
> > that if the gdsc.c file is acked/reviewed.
> 
> Any comments?
> 

Hi,

It will nice if we can progress on this. They are several drivers posted 
already which depends on these regulators, USB3.0 and PCIe, at least.

Thank you.
Ivan
