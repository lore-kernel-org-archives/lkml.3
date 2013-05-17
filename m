Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3EQSyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:54:51 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:42688 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3EQSyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:54:50 -0400
Message-ID: <51967CF5.7060806@schinagl.nl>
Date: Fri, 17 May 2013 20:54:45 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130322 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, maxime.ripard@free-electrons.com,
        arnd@ardb.de, gregkh@linuxfoundation.org,
        Oliver Schinagl <oliver@schinagl.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl> <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl> <4144514.S8gIuIKLrJ@wuerfel>
In-Reply-To: <4144514.S8gIuIKLrJ@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/13 15:45, Arnd Bergmann wrote:
> On Friday 17 May 2013 15:35:43 Oliver Schinagl wrote:
>> +static struct bin_attribute sid_bin_attr = {
>> +       .attr = {
>> +               .name = "key",
>> +               .mode = S_IRUGO,
>> +       },
>> +       .size = SUNXI_SID_SIZE,
>> +       .read = sid_read,
>> +};
>
> I believe all the other drivers in drivers/misc/eeprom use "eeprom"
> as the name for the attribute, so using "key" here is a bit inconsistent.
>
> Can you change that?
Changed, will wait for more feedback and then use that in the final version.

Should there also be a symlink elsewhere in /sys? Just curious is all.
>
> 	Arnd
>

