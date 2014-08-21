Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaHUR3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:29:34 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57901 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaHUR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:29:32 -0400
Message-ID: <53F62C78.8040404@cogentembedded.com>
Date: Thu, 21 Aug 2014 21:29:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] r8152: remove clear_bp function
References: <1394712342-15778-16-Taiwan-albertk@realtek.com> <1394712342-15778-19-Taiwan-albertk@realtek.com> <201408210131.s7L1VuAJ031162@rtits1.realtek.com> <0835B3720019904CB8F7AA43166CEEB2515BB5@RTITMBSV03.realtek.com.tw>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2515BB5@RTITMBSV03.realtek.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 06:12 AM, Hayes Wang wrote:

> [...]
>>>    	r8152b_disable_aldps(tp);
>>>
>>> -	rtl_clear_bp(tp);
>>>

>>      Why leave 2 empty lines? One is enough.

> The next patch would use another fucntion at the
> same location. I skip removing the empty line and
> re-adding it again. Is that better to do so? I would
> resend the patches if the answer is yes.

    Sorry, I haven't looked at your next patch, too big for me. :-)

> Best Regards,
> Hayes

WBR, Sergei

