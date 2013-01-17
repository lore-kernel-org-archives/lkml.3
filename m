Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3AQNhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:37:39 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:41672 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3AQNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:37:38 -0500
Message-ID: <50F7FE9F.8020004@tilera.com>
Date: Thu, 17 Jan 2013 08:37:35 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 35/86] arch/tile/kvm: remove depends on CONFIG_EXPERIMENTAL
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-36-git-send-email-keescook@chromium.org>
In-Reply-To: <1358391258-1771-36-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2013 9:53 PM, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Avi Kivity <avi@redhat.com>
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/tile/kvm/Kconfig |    2 +-

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

