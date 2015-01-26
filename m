Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbbAZRAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:00:12 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34225 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbbAZRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:00:09 -0500
MIME-Version: 1.0
In-Reply-To: <1421169557-18549-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1421169557-18549-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Mon, 26 Jan 2015 12:00:08 -0500
Message-ID: <CAECXXi6+XBq3TcVAt+yNsDCAq=Bz_i3-qm5JngfVEQcVDyOPRg@mail.gmail.com>
Subject: Re: [PATCH] nbd: fix possible memory leak
From: Paul Clements <paul.clements@us.sios.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudip,

On Tue, Jan 13, 2015 at 12:19 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> we have already allocated memory for nbd_dev, but we were not
> releasing that memory and just returning the error value.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>
> Hi Paul,
> after seeing your mail about maintainers, just started to see the code.
> this patch is one way, another way can be to bring the kcalloc part below these checks.

Probably better to move the kcalloc below, rather than adding more
branches, wouldn't you agree?

Thanks,
Paul
