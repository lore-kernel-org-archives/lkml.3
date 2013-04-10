Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3DJKf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:35:28 -0400
Received: from ozlabs.org ([203.10.76.45]:39076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937210Ab3DJKf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:35:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] kernel: module: using strlcpy and strcpy instead of strncpy
In-Reply-To: <5164E6EC.1010803@asianux.com>
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com> <5163814A.2030006@asianux.com> <877gkb89hv.fsf@rustcorp.com.au> <5164E6EC.1010803@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Apr 2013 16:22:28 +0930
Message-ID: <874nfe7u8j.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
>   namebuf is NUL terminated string.  better always let it ended by '\0'.
>
>   the module_name() is always the name field of struct module (which is
>   a fixed array), or a literal "kernel", so strcpy is better.

Thanks, applied.

Cheers,
Rusty.
