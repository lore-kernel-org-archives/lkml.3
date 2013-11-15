Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3KOM3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:29:19 -0500
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:58662 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab3KOM3H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:29:07 -0500
X-Greylist: delayed 6530 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2013 07:29:06 EST
From: Julien DELACOU <julien.delacou@st.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Nov 2013 13:28:38 +0100
Subject: Re: [PATCH] staging: dwc2: do not clear pending interrupts twice
Thread-Topic: [PATCH] staging: dwc2: do not clear pending interrupts twice
Thread-Index: Ac7h/jZMto+erpcQRey31SuchZApFg==
Message-ID: <52861376.3050601@st.com>
References: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
 <20131115105553.GR5302@mwanda>
In-Reply-To: <20131115105553.GR5302@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 11:55 AM, Dan Carpenter wrote:
> On Fri, Nov 15, 2013 at 11:39:38AM +0100, Julien DELACOU wrote:
>> Pending interrupts clearing is done in dwc2_enable_common_interrupts
>> so we don't need to do it twice.
>>
> Are there any user visible effects to this bug?  How did you spot it?
>
> regards,
> dan carpenter
>
>
Honestly, there is not. I am working on another issue using that 
controller and noticed it during reviewing the global behavior.

Best regards,
Julien
