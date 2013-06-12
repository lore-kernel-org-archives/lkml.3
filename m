Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3FLW3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:29:53 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37323 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab3FLW3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:29:52 -0400
Message-ID: <51B8F729.7030907@metafoo.de>
Date: Thu, 13 Jun 2013 00:33:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] pwm: Fill in missing .owner fields
References: <1371036553-32263-1-git-send-email-thierry.reding@gmail.com> <CAK9yfHyUT7KUkY3g2WJ7XiisLL5mvJuenv=UEK_9OqwfF7s4Zg@mail.gmail.com> <20130612195917.GA31835@mithrandir>
In-Reply-To: <20130612195917.GA31835@mithrandir>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 09:59 PM, Thierry Reding wrote:
> On Wed, Jun 12, 2013 at 05:05:18PM +0530, Sachin Kamat wrote:
>> Hi Thierry,
>>
>> On 12 June 2013 16:59, Thierry Reding <thierry.reding@gmail.com> wrote:
>>> Some drivers don't set the .owner fields of the struct device_driver or
>>> struct pwm_ops, which causes the module usage count to become wrong.
>>
>>
>> Recently a patch [1] was added to solve this issue of missing .owner
>> fileds in struct platform_driver.
> 
> Yes I saw that, but thought it might be good to initialize them anyway.
> Especially since a couple of the drivers are I2C and I believe there's
> no similar patch for those. It shouldn't be difficult to come up with
> the corresponding patch, though.

I2C had the same actually for quite some time now.

