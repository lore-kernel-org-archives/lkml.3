Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3BGGu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:50:28 -0500
Received: from asix.com.tw ([113.196.140.82]:63341 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3BGGu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:50:27 -0500
Message-ID: <51134EA1.7000403@asix.com.tw>
Date: Thu, 07 Feb 2013 14:50:09 +0800
From: Freddy <freddy@asix.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: netdev@vger.kernel.org, davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
References: <1360211794-4737-1-git-send-email-freddy@asix.com.tw> <20130206214603.72524632@nehalam.linuxnetplumber.net>
In-Reply-To: <20130206214603.72524632@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 01:46 PM, Stephen Hemminger wrote:
> On Thu,  7 Feb 2013 12:36:34 +0800
> Freddy Xin <freddy@asix.com.tw> wrote:
>
>> +static struct ethtool_ops ax88179_ethtool_ops = {
>> +	.get_link		= ethtool_op_get_link,
>> +	.get_msglevel		= usbnet_get_msglevel,
>> +	.set_msglevel		= usbnet_set_msglevel,
>> +	.get_wol		= ax88179_get_wol,
>> +	.set_wol		= ax88179_set_wol,
>> +	.get_eeprom_len		= ax88179_get_eeprom_len,
>> +	.get_eeprom		= ax88179_get_eeprom,
>> +	.get_settings		= ax88179_get_settings,
>> +	.set_settings		= ax88179_set_settings,
>> +	.nway_reset		= usbnet_nway_reset,
>> +};
>> +
> ethtool_ops should always be const
>
Thank you, Stephen. I will fix these errors.
