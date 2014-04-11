Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaDKIUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:20:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37778 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380AbaDKIUs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:20:48 -0400
Date: Fri, 11 Apr 2014 16:18:43 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/5] Documentation: add the Marvell Berlin
 pinctrl documentation
Message-ID: <20140411161843.0bc75185@xhacker>
In-Reply-To: <20140411081259.GA20147@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
	<20140411143318.67e55a17@xhacker>
	<20140411081259.GA20147@kwain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_03:2014-04-11,2014-04-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404110140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Fri, 11 Apr 2014 01:12:59 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Hi Jisheng,
> 
> On Fri, Apr 11, 2014 at 02:33:18PM +0800, Jisheng Zhang wrote:
> > On Thu, 10 Apr 2014 06:07:53 -0700
> > Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > > +Required subnode-properties:
> > > +- berlin,group: a string describing the group's name.
> > > +- berlin,function: the function used to mux the group.
> > 
> > Would it be better to s/function/mode? Because in mrvl internal technology
> > discussion and docs, we usually say "set pinmux Gy as mode z".
> 
> The pinctrl framework uses 'function', so I guess it's better not to
> introduce an other keyword that may confuse people. But I agree this is not
> what's used in the Marvell's docs. What do you think about we mention it in
> this documentation ?

That's a good idea.

Thanks,
Jisheng
