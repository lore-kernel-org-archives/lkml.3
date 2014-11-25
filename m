Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaKYOyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:54:47 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35306 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKYOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAK8d-aL+3eB4WZeqO1sv9p3440EVXQiqF6QiTU5YNAKAbZ7f-w@mail.gmail.com>
References: <1416419951-27659-1-git-send-email-stevenrwalter@gmail.com>
 <20141120113813.GA23288@t440s.lan> <80321467-10AB-489E-A47E-44B0ECEE4BE1@holtmann.org>
 <CAK8d-aL+3eB4WZeqO1sv9p3440EVXQiqF6QiTU5YNAKAbZ7f-w@mail.gmail.com>
From: Steven Walter <stevenrwalter@gmail.com>
Date: Tue, 25 Nov 2014 09:53:52 -0500
Message-ID: <CAK8d-a+MJBBLkU_=UQGKVmxnM-sYJ=pW7aj0XQ5aa5AuR2G_Wg@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: automatically flushable packets aren't
 allowed on LE links
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:51 AM, Steven Walter <stevenrwalter@gmail.com> wrote:
>> > I think Marcel was after just providing a clarifying code comment in
>> > both places - having two branches of an if-statement doing exactly the
>> > same thing looks a bit weird to me. To make thins completely clear I'd
>> > suggest adding a simple helper function that you can call from both
>> > places to get the needed flags, something like the following:
>>
>> I am actually fine with just adding a comment explaining the complex if
>> statement on why it is correct. It is just a helper for everybody to
>> understand what and why it is done that way.
>
>
> Is the comment I added sufficient, or should I add one for the other if
> condition as well?  To me, the second condition is pretty straightforward:
> if the caller requested it and the hardware supports it, use NO_FLUSH.  The
> relationship between FLUSH/NO_FLUSH and low-energy is much less clear and
> more justifies a comment, in my opinion.

Did a miss a reply to this?  How would you like the next iteration of
the patch to look?
-- 
-Steven Walter <stevenrwalter@gmail.com>
