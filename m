Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaCXJXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:23:35 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39843 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbaCXJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:23:33 -0400
Message-ID: <532FF7BB.5020003@st.com>
Date: Mon, 24 Mar 2014 09:15:39 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Dinh Nguyen <dinh.linux@gmail.com>
Cc: Dinh Nguyen <dinguyen@altera.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        <arm@kernel.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: stmmac-socfpga breakage in arm-soc
References: <201403191333.01095.arnd@arndb.de> <4337501.shzGE38xmF@wuerfel> <5329A7A1.20606@gmail.com> <4171731.dt8xNWCpb2@wuerfel>
In-Reply-To: <4171731.dt8xNWCpb2@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-23_03:2014-03-21,2014-03-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 15:07, Arnd Bergmann wrote:
> Ok, so the two of you basically moved in opposite directions where
> Srinivas started out with the method you ended up with and vice versa.
Yes thats correct, While adding dwmac-sunxi.c we decided to go with
callback methods given its flexibility for calling at runtime(example:
when link speed changes).


--srini
