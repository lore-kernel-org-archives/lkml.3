Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaHYOGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:06:53 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53868 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbaHYOGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:06:51 -0400
Message-ID: <1408975601.5256.44.camel@iivanov-dev>
Subject: Re: [PATCH v3 5/6] ARM: dts: qcom: Add PM8941 and PM8841 pinctrl
 nodes
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2014 17:06:41 +0300
In-Reply-To: <53EC6631.3020203@smartplayin.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
	 <1407771634-14946-6-git-send-email-iivanov@mm-sol.com>
	 <53EC6631.3020203@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 13:03 +0530, Pramod Gurav wrote:
> Hi Ivan,
> This patch fail to apply on linux-next Tree. Probably because this is
> based on Stanimir's older patch series "Support for Qualcomm QPNP
> PMIC's". He has posted v4 of them on which it fails to apply. Am I correct?

Right, sorry about that. I should clearly stated that this is based on Stan's patches.

Regards,
Ivan

