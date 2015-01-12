Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbbALP42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:56:28 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34421 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbALP41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:56:27 -0500
MIME-Version: 1.0
In-Reply-To: <1420994209-20980-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420994209-20980-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 12 Jan 2015 16:56:26 +0100
Message-ID: <CAFLxGvxBbnKugf49_7TtdLh-7QB3Hmv_iqjMqPFbGUDXBcy3yA@mail.gmail.com>
Subject: Re: [PATCH] jffs2: compr_rubin: Remove unused function
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 5:36 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function pulledbits() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks good to me.
Reviewed-by: Richard Weinberger <richard@nod.at>


-- 
Thanks,
//richard
