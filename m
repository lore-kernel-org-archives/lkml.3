Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbbAGPrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:47:13 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60451 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbAGPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:47:12 -0500
Message-ID: <54AD54FC.7040107@android.com>
Date: Wed, 07 Jan 2015 07:47:08 -0800
From: Mark Salyzyn <salyzyn@android.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 1/3] pstore: use scnprintf
References: <1420571907-13162-1-git-send-email-salyzyn@android.com> <1420597507.28667.2.camel@perches.com>
In-Reply-To: <1420597507.28667.2.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 06:25 PM, Joe Perches wrote:
> It'd be nice to describe the changes between versions.
>
> Typically, it's done after the --- line separating the
> changelog and sign-off and the patch.
>
> cheers, Joe
Thanks.

For the record:

Original: used snprintf
V2: switched to scnprintf, but one line-wrap had an embedded space
V3: dropped the embedded space (inert)

Used git-email for submissions for the first time, consider the lack of 
comment learning a new workflow (its been a few years since my last 
submissions, forgive me gohd, for I have sinned)

Sincerely -- Mark Salyzyn
