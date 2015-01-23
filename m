Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbbAWKqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:46:08 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44122 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbbAWKqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:46:05 -0500
Message-ID: <54C22657.8020102@st.com>
Date: Fri, 23 Jan 2015 16:15:43 +0530
From: Amit Virdi <amit.virdi@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Asaf Vertz <asaf.vertz@tandemg.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: zero: fix format string warnings
References: <20150121090633.GA15849@ubuntu>
In-Reply-To: <20150121090633.GA15849@ubuntu>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_03:2015-01-23,2015-01-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2015 2:36 PM, Asaf Vertz wrote:
> Fixed the following warnings (reported by cppcheck):
> [drivers/usb/gadget/function/f_sourcesink.c:1217]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1261]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1305]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1349]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1393]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1437]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1476]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1520]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1564]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/usb/gadget/function/f_sourcesink.c:1608]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'
>
> Signed-off-by: Asaf Vertz<asaf.vertz@tandemg.com>
> ---
>   drivers/usb/gadget/function/f_sourcesink.c |   20 ++++++++++----------
>   1 files changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Amit Virdi <amit.virdi@st.com>
