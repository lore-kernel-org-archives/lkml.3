Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbaGOJGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:06:40 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:25126 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbaGOJGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:06:38 -0400
Message-ID: <53C4EF1B.2050506@imgtec.com>
Date: Tue, 15 Jul 2014 10:06:35 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/38] Delete unused Kbuild files in include/*
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-7-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-7-git-send-email-sam@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 16:08, Sam Ravnborg wrote:
> The following files are not used - and they serve no purpose.
> Delete them.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  include/Kbuild         | 2 --
>  include/scsi/fc/Kbuild | 0
>  include/video/Kbuild   | 0
>  3 files changed, 2 deletions(-)
>  delete mode 100644 include/Kbuild
>  delete mode 100644 include/scsi/fc/Kbuild
>  delete mode 100644 include/video/Kbuild

include/asm-generic/Kbuild.asm could go too since it isn't included
anywhere.

Cheers
James
