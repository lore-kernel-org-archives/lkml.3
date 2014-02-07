Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaBGICQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:02:16 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:44631 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbaBGICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:02:12 -0500
Message-ID: <52F4912A.4040008@st.com>
Date: Fri, 7 Feb 2014 07:54:18 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <stuart.menefy@st.com>, <peppe.cavallaro@st.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Subject: Re: [PATCH v1 1/3] net: stmmac:sti: Add STi SOC glue driver.
References: <1391428787-27143-1-git-send-email-srinivas.kandagatla@st.com>	<1391428868-27245-1-git-send-email-srinivas.kandagatla@st.com> <20140206.195342.1998479313077409827.davem@davemloft.net>
In-Reply-To: <20140206.195342.1998479313077409827.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou Dave,

On 07/02/14 03:53, David Miller wrote:
> From: <srinivas.kandagatla@st.com>
> Date: Mon, 3 Feb 2014 12:01:08 +0000
> 
>> +	res = platform_get_resource_byname(pdev,
>> +				IORESOURCE_MEM, "sti-ethconf");
> 
> This is not the correct way to format multi-line function calls,
> you'll need to fix this up in this entire series.

I will fix this in next version.


> 
> The arguments on the second and subsequent lines must start at
> the first column after the openning parenthesis of the function
> call.  You must use the appropriate number of both space and
> TAB characters necessary to do so.
> 
> If you're only using TAB characters to indent, you're doing it
> wrong.
> 
> Thank you.
> 
> 

Thanks,
srini

