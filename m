Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560Ab3E2DzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:55:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33273 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab3E2DzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:55:07 -0400
Message-ID: <51A57C11.40403@canonical.com>
Date: Wed, 29 May 2013 11:54:57 +0800
From: Bruce <bruce.ma@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org
Subject: Re: Patch for thinkpad-acpi.c
References: <51A47773.4080701@canonical.com> <87r4gr9z5o.fsf@nemi.mork.no>
In-Reply-To: <87r4gr9z5o.fsf@nemi.mork.no>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn

Thank your advice .
I will modify my code, then try to submit again.

Bruce.Ma
May 29,2013


On 05/28/2013 06:28 PM, Bjørn Mork wrote:
> Bruce <bruce.ma@canonical.com> writes:
>
>> +struct blacklist lenovo_blacklist[] = {
>> +  {
>> +    .model_s = "Lenovo LM490s",
>> +    .nummodel_s = "814YG01",
>> +  },
>
> The driver already has a list of LED support per model in the 
>
>   static const struct tpacpi_quirk led_useful_qtable[] __initconst = {}
>
> array.   Why do you duplicate this with lots of new model checking code
> instead of just using the code that's already there?
>
>>  static void led_exit(void)
>>  {
>> +        if (no_led == 1 ) {
>
> The driver already has provisions for signalling that LEDs are
> unsupported through the 'led_supported' variable.  Why do you add
> another variable, and duplicate testing in every access function?
>
> But I don't think this part is needed at all, as long as you set up the
> proper LED map in led_useful_qtable.
>
>
>
> Bjørn

