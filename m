Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaJEWN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:13:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57174 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJEWN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141005215100.GA20426@kroah.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
 <20141005202843.GA1282@kroah.com> <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com>
 <20141005215100.GA20426@kroah.com>
From: Jason Noakes <jjnoakes@gmail.com>
Date: Sun, 5 Oct 2014 18:13:05 -0400
Message-ID: <CAN2+FEKvNz1eCUyThPs3qoX+uG__KzTu67egnu-pz7hxmM9Jjw@mail.gmail.com>
Subject: Re: kobject_init and the zeroed-out-memory requirement
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No driver should be working with "raw" kobjects.

I don't agree, but it's irrelevant. If the functions are exported and
documented, the documentation should be complete.

> kobject_init() has been there for a very long time, and yes, we don't
> always have the best naming scheme in the kernel, that comes from
> evolution over the years.

If you ever want to rename it, drop me a line. I'll submit the patch
for that too :)

> Care to resend this in a format I can apply it in (i.e. without this
> discussion above the patch forcing me to edit the changelog)?

Sure.

-- 
~~ Jason J. Noakes
~~ jjnoakes@gmail.com
