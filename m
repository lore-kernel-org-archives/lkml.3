Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbbAVBTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:19:03 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:47060 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbbAVBSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:18:49 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: fix sys_copyarea
References: <1421885875-24145-1-git-send-email-mans@mansr.com>
Date: Thu, 22 Jan 2015 01:18:40 +0000
In-Reply-To: <1421885875-24145-1-git-send-email-mans@mansr.com> (Mans
	Rullgard's message of "Thu, 22 Jan 2015 00:17:55 +0000")
Message-ID: <yw1xlhkvd34f.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mans Rullgard <mans@mansr.com> writes:

> The sys_copyarea() function performs the same operation as
> cfb_copyarea() but using normal memory access instead of I/O
> accessors.  Since the introduction of sys_copyarea(), there
> have been two fixes to cfb_copyarea():
>
> - 00a9d699 ("framebuffer: fix cfb_copyarea")
> - 5b789da8 ("framebuffer: fix screen corruption when copying")
>
> This patch incorporates the fixes into sys_copyarea() as well.

Scratch that, this patch is broken.  Correct patch coming soon.

-- 
Måns Rullgård
mans@mansr.com
