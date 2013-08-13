Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3HMSSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:18:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43278 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757344Ab3HMSSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:18:13 -0400
Message-ID: <1376417892.1949.41.camel@joe-AO722>
Subject: Re: [PATCH] strlen patch
From: Joe Perches <joe@perches.com>
To: Fred Chen <fchen@linux.vnet.ibm.com>
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Aug 2013 11:18:12 -0700
In-Reply-To: <1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com>
References: <1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 11:13 -0700, Fred Chen wrote:
> fixes sparse error "arch/x86/boot/string.c:119:8: warning: symbol 'strlen' was not declared." by declaring it in arch/x86/boot/boot.h.
[]
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
[]
> @@ -355,6 +355,7 @@ int strncmp(const char *cs, const char *ct, size_t count);
>  size_t strnlen(const char *s, size_t maxlen);
>  unsigned int atou(const char *s);
>  unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
> +size_t strlen(const char *s);

better placed before strnlen no?
 

