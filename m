Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3FYUV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3FYUV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:21:28 -0400
Date: Tue, 25 Jun 2013 22:17:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children
	unconditionally
Message-ID: <20130625201705.GA15966@redhat.com>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net> <20130625201602.GB1726@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625201602.GB1726@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Cyrill Gorcunov wrote:
>
> On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
> > This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
> > is hidden under CONFIG_EXPERT.  It's generally useful functionality,
> > though, so expose it unconditionally.
> >
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

I didn't see the patch but I guess it is trivial and I agree with intent ;)

Oleg.

