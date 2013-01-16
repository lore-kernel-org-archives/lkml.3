Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3APRaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:30:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54432 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3APRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:30:38 -0500
Message-ID: <50F6E3BB.5060007@wwwdotorg.org>
Date: Wed, 16 Jan 2013 10:30:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 5/9] ARM: Tegra: Define Tegra30 CAR binding
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com> <1357890387-23245-6-git-send-email-pgaikwad@nvidia.com> <20130116132856.2896df94f553f78273c4574c@nvidia.com>
In-Reply-To: <20130116132856.2896df94f553f78273c4574c@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 04:28 AM, Hiroshi Doyu wrote:
> On Fri, 11 Jan 2013 08:46:23 +0100
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> 
>> The device tree binding models Tegra30 CAR (Clock And Reset)
>> as a single monolithic clock provider.

>> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt

>> +Example board file:
>> +
>> +/ {
>> +       clocks {
>> +               compatible = "simple-bug";
> 
> typo, 's/simple-bug/simple-bus/' ?

It was rather accurate though; a simple bug:-)

I've squashed the fix into the patch.
