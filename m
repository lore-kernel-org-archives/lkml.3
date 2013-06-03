Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3FCUim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:38:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34475 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3FCUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:38:38 -0400
Message-ID: <51ACFECA.10209@wwwdotorg.org>
Date: Mon, 03 Jun 2013 14:38:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: J Keerthy <j-keerthy@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        t-kristo@ti.com, Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: DT bindings for the palmas family MFD
References: <1370261333-5121-1-git-send-email-j-keerthy@ti.com> <20130603141851.GG3370@gmail.com>
In-Reply-To: <20130603141851.GG3370@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 08:18 AM, Lee Jones wrote:
> On Mon, 03 Jun 2013, J Keerthy wrote:
>> Add the various binding files for the palmas family of chips. There is a
>> top level MFD binding then a seperate binding for regulators IP blocks on chips.

>> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt

>> +Example:
>> +
>> +palmas {
> 
> Should this be 'palmas@48 {', as it has an address?

It's common to only include the unit-address (@48) if it's needed to
make the node name unique (i.e. if you had multiple palmas devices).

>> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt

> See: Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> 
>> +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
>> +	       2 - eco, 3 - forced pwm
> 
> I've seen lots of sleep-mode properties, can't we define a generic
> one?

Isn't it HW-specific?
