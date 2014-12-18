Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaLRSC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLRSC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:02:27 -0500
Message-ID: <549316B1.8010307@redhat.com>
Date: Thu, 18 Dec 2014 10:02:25 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org
CC: nab@linux-iscsi.org, jbastian@redhat.com
Subject: Re: [PATCH] uapi/linux/target_core_user.h: fix headers_install.sh
 badness
References: <20141218175714.GF5157@redacted.bos.redhat.com>
In-Reply-To: <20141218175714.GF5157@redacted.bos.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 09:57 AM, Kyle McMartin wrote:
> scripts/headers_install.sh will transform __packed to
> __attribute__((packed)), so the #ifndef is not necessary.
> (and, in fact, it's problematic, because we'll end up with the header
>   containing:
> #ifndef __attribute__((packed))
> #define __attribu...
> and so forth.)
>
> Cc: stable@vger.kernel.org # 3.18
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
>
> ---
> cc-ing stable@ so this headers fix gets picked up by distros.

Acked-by: Andy Grover <agrover@redhat.com>

