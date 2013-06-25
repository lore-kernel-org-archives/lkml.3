Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3FYUQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:16:07 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:45079 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3FYUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:16:05 -0400
Date: Wed, 26 Jun 2013 00:16:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children
 unconditionally
Message-ID: <20130625201602.GB1726@moon>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
> This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
> is hidden under CONFIG_EXPERT.  It's generally useful functionality,
> though, so expose it unconditionally.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
