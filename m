Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3KFLoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:44:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53455 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab3KFLoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:44:01 -0500
Message-ID: <527A2B37.4040308@ti.com>
Date: Wed, 6 Nov 2013 17:12:47 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Alex Elder <alex.elder@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/6] gpio: davinci: Fixed a check for unbanked gpio
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com> <1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com> <CACRpkdZ7pwGQnK0NN4tybLUNdMxu5WVaGX8Dqu+kMgVBuyF16w@mail.gmail.com> <CA+V-a8tE3bxsHMSh2i3Xeq=kJUjmxTjcU25Kuka5e_iXeB--pQ@mail.gmail.com> <CACRpkdbLTopHMaog7FDW7O4-yLyv+mmnvgkNuXgeQR-pEtbz6Q@mail.gmail.com> <CA+V-a8tZTm9bh+arQ+uFyTVHxfdf07bWaM_Sdqo08TO=UCMMUg@mail.gmail.com> <527A1EC7.20400@ti.com> <527A28EF.9070601@ti.com>
In-Reply-To: <527A28EF.9070601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Wednesday 06 November 2013 05:03 PM, Grygorii Strashko wrote:
> Hi Sekhar, Linus,
> 
> On 11/06/2013 12:49 PM, Sekhar Nori wrote:
>> On Wednesday 06 November 2013 03:45 PM, Prabhakar Lad wrote:
>>> Hi Linus,
>>>
>>> On Wed, Nov 6, 2013 at 3:26 PM, Linus Walleij
>>> <linus.walleij@linaro.org> wrote:
>>>> On Wed, Nov 6, 2013 at 10:33 AM, Prabhakar Lad
>>>> <prabhakar.csengg@gmail.com> wrote:
>>>>> On Tue, Nov 5, 2013 at 6:09 PM, Linus Walleij
>>>>> <linus.walleij@linaro.org> wrote:
>>>>>> On Sat, Nov 2, 2013 at 4:39 PM, Lad, Prabhakar
>>>>>> <prabhakar.csengg@gmail.com> wrote:
>>>>>>
>>>>>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>>>>>
>>>>>>> This patch fixes the check for the offset in
>>>>>>> gpio_to_irq_unbanked() function.
>>>>>>>
>>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>>
>>>>>> Is this a regression that should go in right now?
>>>>>>
>>>>> Yes it needs too.
>>>>
>>>> But on top of *what* exactly?
>>>>
>>>> This does not apply to my gpio tree devel branch and
>>>> not even on the mainline kernel.
>>>>
>>> Looks like this needs to go via ARM tree as the earlier
>>> patches have  gone via ARM tree itself [1].
>>> If you can ACK it Sekhar can get it in via ARM tree.
>>
>> The dependent patches are all in linux-next through ARM SoC queued for
>> v3.13 merge. This fix can either be sent late in merge cycle once Linus
>> has pulled ARM SoC or after v3.13-rc1 comes out.
> 
> Pls, wait a bit - this fix is incomplete :( The below changes have to be
> done too:

Can either you or Prabhakar send a separate patch (series) with only the
fixes?

Thanks,
Sekhar
