Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbaGXIJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:09:49 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44530 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934120AbaGXIJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:09:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140723144111.GA3190@himangi-Dell>
References: <20140723144111.GA3190@himangi-Dell>
Date: Thu, 24 Jul 2014 12:09:43 +0400
Message-ID: <CALFYKtBUjFnS6jH+wWUMTdgSohXNTewYWkM8atM8EiUHZ8=rzw@mail.gmail.com>
Subject: Re: [PATCH] ceph: convert comma to semicolon
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Sage Weil <sage@inktank.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 6:41 PM, Himangi Saraogi <himangi774@gmail.com> wrote:
> Replace a comma between expression statements by a semicolon. This changes
> the semantics of the code, but given the current indentation appears to be
> what is intended.
>
> A simplified version of the Coccinelle semantic patch that performs this
> transformation is as follows:
> // <smpl>
> @r@
> expression e1,e2;
> @@
>
>  e1
> -,
> +;
>  e2;
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.

Thanks,

                Ilya
