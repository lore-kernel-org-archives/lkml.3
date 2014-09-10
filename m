Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaIJNqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:46:47 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33970 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbaIJNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:46:45 -0400
Message-ID: <5410561D.9040707@st.com>
Date: Wed, 10 Sep 2014 15:46:05 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <pza@pengutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL v2] STiH407 reset controller support
References: <20140909213651.GA591@pengutronix.de>
In-Reply-To: <20140909213651.GA591@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-10_03:2014-09-09,2014-09-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 09/09/2014 11:36 PM, Philipp Zabel wrote:
> Hi Maxime,
>
> I have rebased the STiH407 reset controller patches onto v3.17-rc1.
> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
>
>    Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
>
> are available in the git repository at:
>
>    git://git.pengutronix.de/git/pza/linux.git tags/reset-for-sti-3.18
>
> for you to fetch changes up to a83a81838a294adbb5356e6b4a3adcda1439d98e:
>
>    reset: sti: Document sti-picophyreset controllers bindings. (2014-09-04 13:05:01 +0200)
>
> ----------------------------------------------------------------
> STiH407 reset controller support
>
> ----------------------------------------------------------------
> Peter Griffin (2):
>        reset: stih407: Add softreset, powerdown and picophy controllers
>        reset: sti: Document sti-picophyreset controllers bindings.
>
>   .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
>   drivers/reset/sti/Kconfig                          |   4 +
>   drivers/reset/sti/Makefile                         |   1 +
>   drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
>   .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>   5 files changed, 266 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>   create mode 100644 drivers/reset/sti/reset-stih407.c
>   create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
>

Thanks!

Merged into sti-dt-for-v3.18.
It will be available at:
git://git.stlinux.com/devel/kernel/linux-sti.git
in a couple of hours.

Best regards,
Maxime
