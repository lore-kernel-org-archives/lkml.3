Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3LLSig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:38:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40772 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3LLSi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:38:26 -0500
Message-ID: <52AA029D.6040103@wwwdotorg.org>
Date: Thu, 12 Dec 2013 11:38:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] pinctrl: tegra: Add devicetree binding document
 for Tegra124
References: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com> <CACRpkdagtueyzxRqVDWT+x8Sfrf7qR83aYj8oQfrc7Q5qSCjHg@mail.gmail.com>
In-Reply-To: <CACRpkdagtueyzxRqVDWT+x8Sfrf7qR83aYj8oQfrc7Q5qSCjHg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 11:22 AM, Linus Walleij wrote:
> On Mon, Dec 9, 2013 at 11:32 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> 
>> This device tree binding document describes the Tegra124 pincontrol
>> DT bindings. This document lists all valid properties, names, mux
>> options of Tegra124 pins.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>> Changes from V1:
>> - Referred the dt-binding header file on describing the nodes.
> 
> I couldn't quite figure out if this is still under discussion or
> not, I'm holding this off until I have an explicit ACK from
> one of the DT binding people.

Laxman has since sent V3 of this series.

