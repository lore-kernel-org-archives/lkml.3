Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaCJPAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:00:48 -0400
Received: from muin.pair.com ([209.68.1.55]:49258 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbaCJPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:00:47 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2014 11:00:47 EDT
MIME-Version: 1.0
In-Reply-To: <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
	<1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
Date: Mon, 10 Mar 2014 09:54:51 -0500
Message-ID: <CAOZdJXXH-ngaaPRWje8vCNQS1D1movzFt40jGfTM-5F=KNt_WA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
From: Timur Tabi <timur@tabi.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel mailing list <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2014 at 8:42 PM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> For some CODEC drivers like who act as the MFDs children are ignored
> by this patch.

This makes no sense to me.  Is there a comma missing, maybe?
Regardless, I think this patch description is too short.
