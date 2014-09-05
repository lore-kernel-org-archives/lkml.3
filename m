Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaIEHUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:20:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39025 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaIEHUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:20:47 -0400
Message-ID: <54096459.7020201@mm-sol.com>
Date: Fri, 05 Sep 2014 10:20:57 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] pinctrl: qcom: Make the target processor value
 configurable
References: <1409761696-15435-1-git-send-email-gdjakov@mm-sol.com>	<1409761696-15435-5-git-send-email-gdjakov@mm-sol.com> <CACRpkdZQouNk0z1AQHbjULJXdRK07-kZDXLcnx0Xayew0fnocA@mail.gmail.com>
In-Reply-To: <CACRpkdZQouNk0z1AQHbjULJXdRK07-kZDXLcnx0Xayew0fnocA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 07:20 PM, Linus Walleij wrote:
> On Wed, Sep 3, 2014 at 6:28 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> 
>> Currently the value used to specify that interrupts from the gpio should
>> be routed to the application processor is hardcoded for all Qualcomm SoCs.
>> But the new APQ8084 SoC uses a different value. To resolve this, we make
>> this value configurable for each SoC. For all existing SoCs we continue
>> to use the current value, and only for APQ8084 we use the new value.
>>
>> Suggested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> 
> Patch applied.
> 
> Yours,
> Linus Walleij
> 

Thank you, Bjorn and Linus!
