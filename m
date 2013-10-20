Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3JTLdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 07:33:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42317 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3JTLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwgd95ZOGZ_F1_S9skqbrZ2wVV4Zwrd7Q9m92G_4RTnPA@mail.gmail.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<CAFLxGvwgd95ZOGZ_F1_S9skqbrZ2wVV4Zwrd7Q9m92G_4RTnPA@mail.gmail.com>
Date: Sun, 20 Oct 2013 19:33:28 +0800
Message-ID: <CABjrhvpMRJhBPP+T8nWipFkFaoHvCXZn6FQOYkBz--6A0HM37A@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 3:57 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> What about having a good backup and a statically linked busybox
> somewhere on your filesystem?
>

I think it should not be a way for a specific file system but a
mechanism like VFS. Anyway, backup would cost a lot. Thanks.



-- 
 do kernel
