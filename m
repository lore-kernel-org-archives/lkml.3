Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaCVSWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:22:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56538 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaCVSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:22:48 -0400
Message-ID: <532DD4E7.3070706@ahsoftware.de>
Date: Sat, 22 Mar 2014 19:22:31 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] initramfs: print error and shell out for unsupported
 content
References: <532CC625.7020509@ahsoftware.de> <1395491361-28069-1-git-send-email-holler@ahsoftware.de> <1395491361-28069-2-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1395491361-28069-2-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.03.2014 13:29, schrieb Alexander Holler:
> The initramfs generation is broken for file and directory names which contain
> colons, spaces and other unusual characters. Print an error and don't try to
> continue.

(...)
> +	# Files and directories with spaces and colons are unsupported.
> +	local unsupported=$(find "${srcdir}" -regex '.*\(:\| \|\n\|\r\|\t\).*')

I've just noted that -regex isn't POSIX. I don't know the kernel rules 
regarding this, and I don't care. But it might be a blocker for this patch.

Regards,

Alexander Holler


