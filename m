Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaJROmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:42:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaJROmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:42:22 -0400
Message-ID: <54427C48.9050608@nod.at>
Date: Sat, 18 Oct 2014 16:42:16 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Manfred Schlaegl <manfred.schlaegl@gmx.at>, Jeff Dike <jdike@addtoit.com>
CC: Daniel Walter <dwalter@google.com>, Randy Dunlap <rdunlap@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Remove unused bp stack-frame pointer
References: <544277C5.9030302@gmx.at>
In-Reply-To: <544277C5.9030302@gmx.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.10.2014 um 16:23 schrieb Manfred Schlaegl:
> The pointer to bp stack-frame is no longer used. Removed it.

Good catch!

> This also removes a corresponding compiler-warning.

Which warning exactly?

Thanks,
//richard
