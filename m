Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbaCUDRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:17:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58029 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbaCUDRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:17:32 -0400
Date: Fri, 21 Mar 2014 11:14:57 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] ARM: berlin: SMP support
Message-ID: <20140321111457.6bed5091@xhacker>
In-Reply-To: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_06:2014-03-20,2014-03-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403200169
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 13:39:44 -0700
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> This is a small patch set for SMP support on Marvell Berlin BG2
> and recently provided BG2Q. Nothing spectacular, as it basically
> copies SMP holding pen mechanism from mach-prima2 and plat-versatile
> with minor Berlin specific code for SCU and general purpose registers
> used by secondary CPUs to get their boot address.
> 
> There was some IRC discussion with Alexandre about using
> scu_get_base() instead of a DT node. Although BG2Q is true A9
> and provides SCU base; BG2 with PJ4b does not and I decided to
> depend on a DT node for SCU in both cases, which is fine I guess.
> 
> I tested this on BG2, and BG2CD (which is UP). I expect the
> Free-Electrons guys to test on BG2Q.

Although BG2Q and future SoCs will go through PSCI code path finally. But
currently, it's OK to use the pen mechanism.

So for both of these two patches, 

Acked-by: Jisheng Zhang <jszhang@marvell.com>

Thanks,
Jisheng
