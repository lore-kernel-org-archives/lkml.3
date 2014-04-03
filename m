Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaDCJSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:18:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59799 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaDCJSD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:18:03 -0400
Date: Thu, 3 Apr 2014 17:14:15 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: document the berlin enable-method
 property
Message-ID: <20140403171415.13adae45@xhacker>
In-Reply-To: <533D21AF.2070508@free-electrons.com>
References: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
	<1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com>
	<20140403162202.79b63729@xhacker>
	<533D21AF.2070508@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-03_02:2014-04-02,2014-04-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404030025
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Thu, 3 Apr 2014 01:54:07 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Jisheng,
> 
> On 03/04/2014 10:22, Jisheng Zhang wrote:
> > Hi,
> >
> > On Thu, 3 Apr 2014 01:08:15 -0700
> > Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> >
> >> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> >> ---
> >>   Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt
> >> b/Documentation/devicetree/bindings/arm/cpus.txt index
> >> 333f4aea3029..a9e42a2dbc99 100644 ---
> >> a/Documentation/devicetree/bindings/arm/cpus.txt +++
> >> b/Documentation/devicetree/bindings/arm/cpus.txt @@ -185,6 +185,8 @@
> >> nodes to be present and contain the properties described below.
> >> "qcom,gcc-msm8660" "qcom,kpss-acc-v1"
> >>   			    "qcom,kpss-acc-v2"
> >> +			    "marvell,88de31-smp" - cpu-core handling for
> >
> > why not "marvell,berlin-smp"?
> 
> We have SMP on the BG2 and the BG2Q currently. Future boards may not be 
> compatible with this method (BG3 ?), I think "marvell,berlin-smp" is too 

Yes. It's not compatible. But it will be PSCI. FWICT, current smp method
would be only used for BG2/BG2CT.

Thanks
