Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3KGHEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:04:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49487 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab3KGHEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:04:35 -0500
Date: Thu, 7 Nov 2013 15:01:39 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Jisheng Zhang <jszhang@marvell.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
Message-ID: <20131107150139.26b321f4@xhacker>
In-Reply-To: <20131107134033.59bd127a@xhacker>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1383661723-17956-10-git-send-email-sebastian.hesselbarth@gmail.com>
	<20131107134033.59bd127a@xhacker>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_03:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060317
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 21:40:33 -0800
Jisheng Zhang <jszhang@marvell.com> wrote:

...
> > +	select ARM_GIC  
> ARM_GIC is common on berlin SoCs. we can put it below ARCH_BERLIN?
> > +	select CACHE_L2X0  
> ditto

Sorry. After some consideration, CACHE_L2X0 is not common (BG3). So please ignore
this line

Thanks
