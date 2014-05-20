Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaETOki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:40:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbaETOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:40:37 -0400
Date: Tue, 20 May 2014 16:40:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kees Cook <keescook@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Simon Wood <simon@mungewell.org>,
        linux-input <linux-input@vger.kernel.org>,
        Roland Bosa <rbosa@logitech.com>
Subject: Re: [PATCH] HID: core: fix validation of report id 0
In-Reply-To: <CAGXu5jJLKQiC4zwYJ9dpVvELoYBKZ4OFsqKdQXQW9OyDwsdvmg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1405201640020.1615@pobox.suse.cz>
References: <20140417202209.GA30268@www.outflux.net> <CAGXu5jJLKQiC4zwYJ9dpVvELoYBKZ4OFsqKdQXQW9OyDwsdvmg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Kees Cook wrote:

> Pinging on this patch... I don't see it in -next yet. I've had more
> reports of trouble with logitech devices, and this seems to solve the
> problem.

Apologizes for this taking so long time. I have now queued your patch. 
Thanks,

-- 
Jiri Kosina
SUSE Labs
