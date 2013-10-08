Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3JHSiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab3JHSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:38:24 -0400
Message-ID: <1381257497.8305.15.camel@deneb.redhat.com>
Subject: Re: [PATCH 05/29] c6x: Use get_signal() signal_setup_done()
From: Mark Salter <msalter@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 14:38:17 -0400
In-Reply-To: <1381231701-4008-6-git-send-email-richard@nod.at>
References: <1381231701-4008-1-git-send-email-richard@nod.at>
	 <1381231701-4008-6-git-send-email-richard@nod.at>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 13:27 +0200, Richard Weinberger wrote:
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/c6x/kernel/signal.c | 43
> ++++++++++++++++++-------------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)

Tested-by: Mark Salter <msalter@redhat.com>
Acked-by: Mark Salter <msalter@redhat.com>


