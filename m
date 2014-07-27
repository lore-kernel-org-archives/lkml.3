Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaG0IrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 04:47:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaG0Iq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 04:46:59 -0400
Message-ID: <53D4BC7D.7030008@nod.at>
Date: Sun, 27 Jul 2014 10:46:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: zubraz singha <zubrajsingha@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: "copy_to_user" function not working in stable build "2.6.36.4"
References: <CAPb+xgO9_7FQ3NM1NCL8zW5hMzUcWASxu-mk3e64Y+V_DnkMzg@mail.gmail.com>	<CAFLxGvyD-R-ex8OadHV9pkz7gGOf09_8qfAwq-xB1URZqFH33w@mail.gmail.com> <CAPb+xgP+1MvSJsQkdsTT-W3VXCHLYV2FyQ_bNO=Seb6RKbVKPA@mail.gmail.com>
In-Reply-To: <CAPb+xgP+1MvSJsQkdsTT-W3VXCHLYV2FyQ_bNO=Seb6RKbVKPA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.07.2014 10:44, schrieb zubraz singha:
> I do understand that this is a very old build and its not being
> supported. As I wrote in my earlier mail,  the function works fine
> with higher kernel versions. I will try to find out a work around for
> this. Appreciate your feedback.

First I'd look into 2.6.32.x. Maybe it needed fixing and you can forward port the fix. :)

Thanks,
//richard
