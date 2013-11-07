Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab3KGEN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:13:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20461 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KGEN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:13:27 -0500
Message-ID: <527B1399.8090805@oracle.com>
Date: Thu, 07 Nov 2013 12:14:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: stephan.mueller@atsec.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Andreas Dilger <aedilger@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "Ted Ts'o" <tytso@mit.edu>,
        jakub@redhat.com, drepper@redhat.com,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy
 depleting
References: <50A46BBD.3060701@oracle.com>
In-Reply-To: <50A46BBD.3060701@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

As per your previous comments for this fix, you have promised another approach which
is promising to avoid entropy starvation, I got this info from the following thread:
[PATCH] avoid entropy starvation due to stack protection
https://lkml.org/lkml/2012/12/14/267

My current fix has been merged into Andrew's tree(marked in "stuck" state) for a long
time, and it also works well in our internal specific kernel, I'd like to know if there
is any update from you, so that we can move it along for mainline. :)

Thanks,
-Jeff
