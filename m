Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3BFO0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:26:19 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52128 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BFO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:26:18 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] sta2x11_vip: convert to videobuf2, control framework, file handler
Date: Wed, 06 Feb 2013 15:26:04 +0100
Message-ID: <3571679.eOuhae6qJb@number-5>
User-Agent: KMail/4.9.5 (Linux/3.7.4-204.fc18.x86_64; KDE/4.9.5; x86_64; ; )
In-Reply-To: <201302061049.10879.hansverk@cisco.com>
References: <201302041157.45340.hverkuil@xs4all.nl> <1360089277-27898-1-git-send-email-federico.vaga@gmail.com> <201302061049.10879.hansverk@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

thank you very much for your review and your patience.

> OK, I'm going to give this my Acked-by, but I really wish you would
> have split this up into smaller changes. It's hard to review since
> you have made so many changes in this one patch. Even though I'm
> giving my ack, Mauro might decide against it, so if you have time
> to spread out the changes in multiple patches, then please do so.

I tried to do smaller patch but there is always some incoherent part 
and the driver cannot work without all the patches. I should write 
some "fake" patches to make a coherent series.
I reduce the size of the patch since v4/5; I leaved 
unchanged some code/comments to simplify the patch.

> So, given the fact that this changes just a single driver not
> commonly used in existing deployments, assuming that you have
> tested the changes (you did that, right? Just checking...), that
> these are really useful improvements, and that I reviewed the code
> (as well as I could) and didn't see any problems, I'm giving my ack
> anyway:

Tested every time I sent a patch

> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thank you again

-- 
Federico Vaga
