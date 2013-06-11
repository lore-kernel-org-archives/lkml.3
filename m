Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3FKU3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:29:47 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41322 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3FKU3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <51B78594.5050903@windriver.com>
References: <1370962642-12097-1-git-send-email-markos.chandras@imgtec.com>
 <51B75088.8050800@windriver.com> <CAG2jQ8hACp_iGEXR7rXKR3sydK4O=y0paeh1FFgH2UisxWVxVA@mail.gmail.com>
 <51B78594.5050903@windriver.com>
From: Markos Chandras <markos.chandras@gmail.com>
Date: Tue, 11 Jun 2013 21:29:03 +0100
Message-ID: <CAG2jQ8jcZGW=9Tsb9c+YVEa0dPtgABJpYxWghdWp0-GGHYoQ2Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/ethernet/3com: Drop EISA dependency from VORTEX
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2013 21:16, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>>
>> Hi Paul,
>>
>> The driver does not seem to build if you only have EISA=y and PCI=n.
>> Does this driver really support EISA only
>
> Yes.  Not that anyone really probably cares anymore.  EISA is dead.
>
>> configurations? Reading the code it seems to me that the PCI support
>> is mandatory for the driver to build and work.
>
> Oh really?  Having PCI disabled seems fine on today's net-next tree
> from what I see below:

Hi Paul,

Ok I guess I was wrong then.

--
Regards,
Markos Chandras
