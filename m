Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaHKF5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:57:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaHKF5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:57:52 -0400
Message-ID: <53E85B5D.70202@infradead.org>
Date: Sun, 10 Aug 2014 22:57:49 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Documentation: DocBook: Rename drm_stub.c to drm_drv.c
 cause 'make xmldocs' failed
References: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/14 12:16, Masanari Iida wrote:
> This patch fixed 'make xmldocs' failed on linus's tree and
> linux-next as of 8th/Aug,2014.
> 
> When drm merge for 3.17-rc1 happen,  a file was renamed from
> drm_stub.c to drm_drv.c.
> But Documentation/DocBook/drm.tmpl still have an old file name.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

Linus, please merge as it fixes a DocBook build error.


> ---
>  Documentation/DocBook/drm.tmpl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
> index 1d3756d..bacefc5 100644
> --- a/Documentation/DocBook/drm.tmpl
> +++ b/Documentation/DocBook/drm.tmpl
> @@ -315,7 +315,7 @@ char *date;</synopsis>
>          <function>drm_dev_unregister()</function> followed by a call to
>          <function>drm_dev_unref()</function>.
>        </para>
> -!Edrivers/gpu/drm/drm_stub.c
> +!Edrivers/gpu/drm/drm_drv.c
>      </sect2>
>      <sect2>
>        <title>Driver Load</title>
> 


-- 
~Randy
