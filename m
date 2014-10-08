Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaJHLNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:13:35 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37321 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbaJHLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:13:31 -0400
Message-ID: <54351C25.70604@st.com>
Date: Wed, 8 Oct 2014 13:12:37 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>, <b29396@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lee.jones@linaro.org>
Cc: <sameo@linux.intel.com>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/2] mfd: syscon: declare holes in syscon register
 maps
References: <54244655.1090801@st.com> <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
In-Reply-To: <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-08_06:2014-10-08,2014-10-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seraphin,

On 10/07/2014 03:22 PM, Seraphin Bonnaffe wrote:
> In reply to mail: Holes management in syscon driver.
> 
> Hi Dong, Maxime, Lee, all,
> 
> Regmap also offers .rd_table and .wr_table structures that can be used to
> specify valid ranges within agiven regmap configuration.
> 
> This patch uses these structures to declare holes in a syscon instance.
> It takes the description from DT, and fills in the structures accordingly.
> 
> Can I have your opinion on this implementation ?

As discussed face to face, it looks fine to me.

But we would like green light in the new "holes" property introduced.

Thanks,
Maxime

> 
> Thanks and Regards,
> Seraphin
> 
> Seraphin Bonnaffe (2):
>    mfd: syscon: Document new DT binding "holes"
>    mfd: syscon: specify rd_table and wr_table from DT
> 
>   Documentation/devicetree/bindings/mfd/syscon.txt |  5 ++++
>   drivers/mfd/syscon.c                             | 35 ++++++++++++++++++++++++
>   2 files changed, 40 insertions(+)
> 
