Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3LKJio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:38:44 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:55490 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab3LKJik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:38:40 -0500
Message-ID: <52A83258.5070506@st.com>
Date: Wed, 11 Dec 2013 09:37:28 +0000
From: Angus Clark <angus.clark@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100312 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linus.walleij@linaro.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH v3 01/36] mtd: st_spi_fsm: Allocate resources and register
 with MTD framework
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-2-git-send-email-lee.jones@linaro.org> <20131210204635.GD27149@ld-irv-0074.broadcom.com> <20131211084856.GF2390@lee--X1>
In-Reply-To: <20131211084856.GF2390@lee--X1>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.49.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee and Brian,

I would also like to thank Brian; as always, very sensible comments.

I am tied up most of today and off work tomorrow (Christmas shopping!), but I
will set aside Friday to go through the comments in detail.  I should also have
some time next week if necessary, subject to any panics that might arise!

I also intend to respond to Huang's updated 'spi-nor' framework at the same
time.  At some stage, I would expect some of the device probing code in
st_spi_fsm, particularly the configuration of read/write/erase operations based
on capabilities, to be pulled into the 'spi-nor' framework.  I do not see this
an an obstacle to st_spi_fsm being integrated earlier though; it's presence in
the kernel would provide another example of a H/W Controller that 'spi-nor'
needs to accommodate.

Cheers,

Angus


On 12/11/2013 08:48 AM, Lee Jones wrote:
> Hi Brian,
> 
> Thank you for taking the time to review, it's very much appreciated.
> You bought out some interesting points that I'm happy to go away and
> rectify. Firstly however, as I inherited this code I'd like to give
> Angus a chance to comment before we go off on our own tangent and
> rework some of the good code which perhaps should remain unchanged.
> 
> Angus, do you have enough time to go through Brian's review comments
> and perhaps reply to the ones that you feel would benefit from your
> expert knowledge. To be frank, some of the questions that were asked I
> wouldn't be able to answer without your guidance in any case.
> 
> Thanks both.
> 
> Kind regards,
> Lee
> 

