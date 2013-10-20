Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3JTLhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 07:37:05 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43955 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3JTLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
Date: Sun, 20 Oct 2013 19:37:01 +0800
Message-ID: <CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 6:43 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> Anyway, you need to use Copy-On-Write (COW) approach for such file system.
> But there are file systems that implements snapshot approach yet: NILFS2, ext3cow,
> Next3, and so on.
>

Any file system should rollback but not specific ones. Therefore, a
VFS like mechanism should be designed and implemented.

> Do you really want to implement something likewise snapshot feature in a file system
> from the scratch?
>

Maybe, I would give detail design, thanks.




-- 
 do kernel
