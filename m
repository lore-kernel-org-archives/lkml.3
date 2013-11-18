Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KRBsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:48:21 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53036 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3KRBsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:48:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAK2Ky6zUfngvgKAaqNzTN9KPY2zgir3Yevj-r_=wWq=1RN3yAw@mail.gmail.com>
References: <CAK2Ky6zUfngvgKAaqNzTN9KPY2zgir3Yevj-r_=wWq=1RN3yAw@mail.gmail.com>
Date: Sun, 17 Nov 2013 17:48:14 -0800
Message-ID: <CAK7N6vpL+zXrb+2uoT3=kggAin34k+FkB-bt1_Sgw17uC5MkLQ@mail.gmail.com>
Subject: Re: list_head and lock?
From: anish singh <anish198519851985@gmail.com>
To: =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 5:19 PM, 韩磊 <bonben1989@gmail.com> wrote:
> when we delete,add,search,amend the list_head,should we use spinlock
> or rcu in case of conflicit to list_head???
There is no implicit locking when we use 'list' api's.You should explicitly
do that AFAIK.
>
> Thank you!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
