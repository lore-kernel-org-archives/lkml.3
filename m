Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaCYIak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:30:40 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52770 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340AbaCYIad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:30:33 -0400
Message-ID: <53313E39.9080605@st.com>
Date: Tue, 25 Mar 2014 09:28:41 +0100
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH v0 01/15] drivers: clk: st: Support for DIVMUX and PreDiv
 Clocks
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com> <1393514668-17440-2-git-send-email-gabriel.fernandez@st.com> <20140325052725.32624.39974@quantum>
In-Reply-To: <20140325052725.32624.39974@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-25_03:2014-03-24,2014-03-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I want that you take theses patches directly.

Many thanks


Best regards

Gabriel.


On 03/25/2014 06:27 AM, Mike Turquette wrote:
> Quoting Gabriel FERNANDEZ (2014-02-27 07:24:14)
>> +/**
>> + * DOC: Clock mux with a programmable divider on each of its three inputs.
>> + *      The mux has an input setting which effectively gates its output.
>> + *
>> + * Traits of this clock:
>> + * prepare - clk_(un)prepare only ensures parent is (un)prepared
> Minor nitpick but it doesn't look like .prepare or .unprepare are
> supported below. It looks like this copy/paste comment applies to most
> of the clk patches as well.
>
> It's a small problem and doesn't require a patch respin. But perhaps can
> be cleaned up some day in the future.
>
> Do you want me to take these patches directly or are you just looking
> for an Ack?
>
> Regards,
> Mike

