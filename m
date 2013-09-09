Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3IIUa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:30:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44600 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab3IIUaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:30:55 -0400
Message-ID: <1378758647.2257.136.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        David Lang <david@lang.hm>
Date: Mon, 09 Sep 2013 16:30:47 -0400
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090920-7182-0000-0000-000008580EF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 11:49 -0400, Matthew Garrett wrote:
> Some use cases require the ability to ensure that anything running in ring 0
> is trusted code. We have support for signing the kernel and kernel modules,
> but there's still a range of exported kernel interfaces that make it easy to
> modify the running kernel. Previous attempts to implement a generic interface
> to restrict this have included a new capability (breaks existing userspace)
> and tying it to a requirement for signed modules (breaks assumptions in
> certain situations where userspace is already running with restricted
> privileges).
> 
> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot. There's strong parallels
> between the functionality that I'm interested in and the BSD securelevel
> interface, so here's a trivial implementation. 

Thank you for not tying this functionality to UEFI secure boot.  There
are, and will continue to be, many systems out there that don't support
UEFI secure boot, yet would be interested in this functionality.

As David Lang aptly said, "... security is not a binary thing, just
because there is one hole, it isn't worthless to close another one."

Mimi

