Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaCYCfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:35:07 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:54121 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaCYCfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:35:05 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-bb-5330eb57e4f4
Message-id: <5330EB4E.1080304@samsung.com>
Date: Mon, 24 Mar 2014 20:34:54 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: john@jjdev.com, ced@ryick.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] staging/usbip: fix store_attach() sscanf return value check
References: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
 <20140325003854.GB10953@kroah.com>
In-reply-to: <20140325003854.GB10953@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.214]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9hP93w1wbBBm928Vg8X9/NZrHnzC92
	i+bF69ksOqfOY7e4vGsOm8WiZa3MFl9/Ojiwe9zbd5jFY+esu+weE2bdZPXYP3cNu8fsZ2dZ
	PD5vkgtgi+KySUnNySxLLdK3S+DKuL9zHVPBOpaKvZPeszcw7mLuYuTkkBAwkTg75T4bhC0m
	ceHeeiCbi0NIYBmjxI5tB9khnF4miWm3ulkhnG2MEjOvdLCCtPAKaEn8e/AXzGYRUJU4vHwy
	2Cg2AXWJz693sIPYQgJyEk1LVoOtExWIkHh1diILRK+gxI/J98BsEQENiZdHb7GALGAW2MQo
	cXDPOSCHg0NYIEBi09sYEFNIIEPi1sQIkHJOAX2Jv6+nMILYzALWEisnbYOy5SU2r3nLDLFW
	WeLP5VNMEJ8pS/zo/M80gVFkFpLNs5C0z0LSvoCReRWjWGlxckFxUnpqhaFecWJucWleul5y
	fu4mRkhEVe1gvPPV5hCjAAejEg/vBlODYCHWxLLiytxDjBIczEoivPc3AoV4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUw9lg7ecjMeH31nQWT+/c12/89YcmTCv90WSvDSTns4s3T6kWpW3ZtS4vt
	PVMnUOO5Tt/1z8OcbN/N0+UZZk/gsf6wcu3p8CA2w4vsWQte/9Xunfygwr5CcfMDfb+d3954
	TpgkZBR14fbJmY3Tgxac6Hsat61S6HK9VMaZqIf2kxn6FeqWRk2VV2Ipzkg01GIuKk4EAPPX
	LDCGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 06:38 PM, Greg KH wrote:
> On Mon, Mar 24, 2014 at 05:12:09PM -0600, Shuah Khan wrote:
>> Fix commit - 88fa1ebfa21b5deaaad2dc88ecd9f6af91796cf7
>
> What do you mean by this line?
>

Nothing really. Sloppiness on my part. I was keeping notes as I was 
chasing the problem and those ended up in the change log. Sorry about. 
Will fix the change log and resend the patch.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
