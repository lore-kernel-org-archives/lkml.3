Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3AOKEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:04:47 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52068 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3AOKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:04:43 -0500
Message-ID: <50F52986.2080002@lab.ntt.co.jp>
Date: Tue, 15 Jan 2013 19:03:50 +0900
From: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add support for Sony RF receiver with USB product
 id 0x0374
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp> <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>
In-Reply-To: <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

On 2013/01/15 18:36, Antonio Ospite wrote:
> On Tue, 15 Jan 2013 12:43:48 +0900 Fernando Luis Vázquez Cao  <fernando_b1@lab.ntt.co.jp> wrote:
>> diff -urNp linux-3.8-rc3-orig/drivers/hid/hid-sony.c linux-3.8-rc3/drivers/hid/hid-sony.c
>> --- linux-3.8-rc3-orig/drivers/hid/hid-sony.c	2012-12-11 12:30:57.000000000 +0900
>> +++ linux-3.8-rc3/drivers/hid/hid-sony.c	2013-01-13 18:21:19.901347327 +0900
>> @@ -44,19 +44,21 @@ static __u8 *sony_report_fixup(struct hi
>>   	struct sony_sc *sc = hid_get_drvdata(hdev);
>>   
>>   	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
>> -			*rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
>> -		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
>> +	    *rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
>> +		hid_info(hdev,
>> +		         "Fixing up Sony RF Receiver report descriptor\n");
> Changing the message does make sense, but try to avoid mixing
> functional changes with style changes (I am referring to the change of
> indentation here).

Oops, that was unintended. I will be replying to this email with an 
updated version.

Thanks,
Fernando
