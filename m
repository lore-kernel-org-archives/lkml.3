Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3FSQJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab3FSQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:09:40 -0400
Date: Wed, 19 Jun 2013 18:09:30 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
Message-ID: <20130619160930.GA15631@host2.jankratochvil.net>
References: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013 17:15:36 +0200, Denys Vlasenko wrote:
> CCing Jan to hear his comments from gdb side.

GDB never calls PTRACE_DETACH without having the inferior already stopped.


Jan
