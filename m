Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaIMQgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:36:55 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33823 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaIMQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:36:53 -0400
Message-ID: <54147292.2000901@samsung.com>
Date: Sun, 14 Sep 2014 01:36:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        linux-samsung-soc@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Yufeng Shen <miletus@chromium.org>, afaerber@suse.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/3] ARM: dts: Add Peach Pit dts entry for Atmel touchpad
References: <1410348691-18317-1-git-send-email-javier.martinez@collabora.co.uk> <1410348691-18317-2-git-send-email-javier.martinez@collabora.co.uk> <20140910222553.GF38736@core.coreip.homeip.net> <54116F07.9090007@collabora.co.uk>
In-Reply-To: <54116F07.9090007@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/14 18:44, Javier Martinez Canillas wrote:
> Hello Dmitry,
>
Hi,

> On 09/11/2014 12:25 AM, Dmitry Torokhov wrote:
>>>
>>> +&hsi2c_8 {
>>> +	status = "okay";
>>> +	clock-frequency =<333000>;
>>> +
>>> +	/* Atmel mXT336S */
>>> +	trackpad@4b {
>>> +		compatible = "atmel,maxtouch";
>>> +		reg =<0x4b>;
>>> +		interrupt-parent =<&gpx1>;
>>> +		interrupts =<1 IRQ_TYPE_EDGE_FALLING>;
>>> +		wakeup-source;
>>> +		pinctrl-names = "default";
>>> +		pinctrl-0 =<&trackpad_irq>;
>>> +		linux,gpio-keymap =<KEY_RESERVED
>>> +				     KEY_RESERVED
>>> +				     KEY_RESERVED	/* GPIO0 */
>>> +				     KEY_RESERVED	/* GPIO1 */
>>> +				     KEY_RESERVED	/* GPIO2 */
>>> +				     BTN_LEFT>; 	/* GPIO3 */
>>
>> Seems like a single space sneaked between the semicolon and the tab.
>> Maybe whoever applies could squash it.
>>
>
> Right, I set c-default-style to "linux" on Emacs but seems it gets confused
> sometimes when editing Device Tree source files. Sorry about that.
>
Applied this whole series with fixing a white space Dmitry commented.

Note, I will handle all of exynos_defconfig changes separately.

Thanks,
Kukjin
