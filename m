Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3KLNtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:49:04 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751610Ab3KLNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:49:03 -0500
Message-ID: <528231C5.9010101@nod.at>
Date: Tue, 12 Nov 2013 14:48:53 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 11/11] um: use generic fixmap.h
References: <1384262545-20875-1-git-send-email-msalter@redhat.com> <1384262545-20875-12-git-send-email-msalter@redhat.com>
In-Reply-To: <1384262545-20875-12-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.11.2013 14:22, schrieb Mark Salter:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Jeff Dike <jdike@addtoit.com>
> CC: Richard Weinberger <richard@nod.at>
> CC: user-mode-linux-devel@lists.sourceforge.net
> ---
>  arch/um/include/asm/fixmap.h | 40 +---------------------------------------
>  1 file changed, 1 insertion(+), 39 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
