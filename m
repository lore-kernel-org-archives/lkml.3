Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaAQX1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:27:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58635 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaAQX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:27:26 -0500
Message-ID: <52D9BC5B.30304@wwwdotorg.org>
Date: Fri, 17 Jan 2014 16:27:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Sherman Yin <syin@broadcom.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Christian Daudt <bcm@fixthebug.org>
Subject: Re: [PATCH] pinctrl: capri: add dependency on OF
References: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>	<52D989C2.6030603@broadcom.com>	<CACRpkdYVLF+CNcAc8=MiSRJJMBWy3LriDw271Bx=gjuuzdOatA@mail.gmail.com> <CACRpkdZ9OBkKaLuQbc1oz0uPePBtqttGyOwV02iFWZ+CT1gwnw@mail.gmail.com>
In-Reply-To: <CACRpkdZ9OBkKaLuQbc1oz0uPePBtqttGyOwV02iFWZ+CT1gwnw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 04:13 PM, Linus Walleij wrote:
> On Sat, Jan 18, 2014 at 12:12 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>> On Fri, Jan 17, 2014 at 8:51 PM, Sherman Yin <syin@broadcom.com> wrote:
>>
>>> Thanks for the fix, Linus.  While we're visiting this config, should we add
>>> "depends on MACH_BCM_MOBILE" as well?
>>
>> No, it's nice to get the compile coverage.
> 
> But maybe you can experiment with that special option that only
> turns on the driver on other platforms to do compile test.

a/k/a
depends on XXX || COMPILE_TEST
