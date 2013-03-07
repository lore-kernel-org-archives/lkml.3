Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3CGJOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:14:38 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:39330 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab3CGJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:14:32 -0500
Message-ID: <513854BE.5000700@st.com>
Date: Thu, 07 Mar 2013 09:50:06 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Byungho An <bh74.an@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH net-next 1/3] net: stmmac: add gmac autoneg set for SGMII,
 TBI, and RTBI
References: <00c001cdf369$9b25bdf0$d17139d0$@samsung.com> <50F6568D.3060703@st.com> <01e201cdf5a3$1f3e1890$5dba49b0$@samsung.com> <50FFB094.5000100@st.com> <013e01cdfb47$8f5d2b30$ae178190$@samsung.com> <51277004.20702@st.com> <022601ce1a20$ff6b2290$fe4167b0$%an@samsung.com>
In-Reply-To: <022601ce1a20$ff6b2290$fe4167b0$%an@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2013 5:13 AM, Byungho An wrote:
> Hello Peppe,
>> If you agree, you could also re-send *all* to the mailing list to
>> be finally reviewed.
>>
>
> Anyway, in my opinion, you can take them in your tree for now with my
> tested-by if you want. Of course, I'll implement additional patches as you
> requested on top of them for remained stuff such as SGMII, TBI, ethtool and
> so on.
> I think those should be separated for each purpose and we can add and modify
> after those two patches.

Ok Byungho, I'm preparing a new update for the stmmac that will also 
include the initial support for SGMII and RGMII. Thx to have tested it!

Obviously on top of these patches, feel free to add further code.
TBI and RTBI are not supported yet.


P.S. in this update I've also added the ethtool missing stuff ;-)

Peppe
