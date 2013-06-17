Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3FQDPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:15:25 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:54927 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3FQDPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:15:24 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.127.220]
In-Reply-To: <1371357768-4968-6-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au> <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
 <1371357768-4968-6-git-send-email-rusty@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 17 Jun 2013 06:15:02 +0300
Message-ID: <CAK=WgbbC9=H=VL9ugSAoGZXu0mSRB+NRoVYzkDdKw0M=L4v5aQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] remoteproc: don't use PTR_RET().
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 7:42 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> We've already tested that it's an error.
>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Robert Tivy <rtivy@ti.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Thanks Rusty, feel free to take it via your tree together with the
rest of the PTR_RET patches.
