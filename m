Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab3GSRnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:43:24 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54646 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294Ab3GSRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <51E97779.3020103@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 19 Jul 2013 23:12:42 +0530
Message-ID: <CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com>
Subject: Re: [QUERY] lguest64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> We want to reduce pvops and pvops users, not increase them...

I see.  So the future is true virtualization which exposes the
underlying hardware, like KVM?  Why do bare-metal virtualizers like
Xen employ paravirtualization?  Also, where does UML stand?

Thanks.
