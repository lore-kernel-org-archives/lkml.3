Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3DLKjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:39:14 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:51815 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3DLKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:39:13 -0400
Message-ID: <5167E440.6070606@synopsys.com>
Date: Fri, 12 Apr 2013 16:08:56 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Mike Turquette" <mturquette@linaro.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] ARC: [TB10x] Adapt device tree to new compatible string
References: <5167D7E4.9030206@free-electrons.com> <1365762989-31638-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1365762989-31638-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 04:06 PM, Christian Ruppert wrote:
> The original device tree was written using a slightly different
> implementation of the fixed-factor-clock device tree binding. The
> compatible string must be modified in order to be compatible with the
> new implementation.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

Applied !

Thx,
-Vineet
