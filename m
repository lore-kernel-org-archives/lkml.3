Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3H2SWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:22:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40627 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab3H2SWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:22:41 -0400
Message-ID: <521F9162.9060405@zytor.com>
Date: Thu, 29 Aug 2013 11:22:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        jwboyer@redhat.com, keescook@chromium.org
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com> <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 09:10 AM, Matthew Garrett wrote:
> +	if (!capable(CAP_COMPROMISE_KERNEL))
> +		return -EPERM;
> +

Stale bits?

	-hpa


