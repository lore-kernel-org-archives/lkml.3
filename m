Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaDUQ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:26:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33220 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaDUQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:26:25 -0400
Message-ID: <535546AF.6000002@infradead.org>
Date: Mon, 21 Apr 2014 09:26:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: drm: Fix typo in drm.tmpl
References: <1398097026-13800-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398097026-13800-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 09:17 AM, Masanari Iida wrote:
> Fix spelling typo in DocBook/drm.tmpl
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied.  Thanks.

> ---
>  Documentation/DocBook/drm.tmpl | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
> index 702c4474..bdb932f 100644
> --- a/Documentation/DocBook/drm.tmpl
> +++ b/Documentation/DocBook/drm.tmpl
> @@ -79,7 +79,7 @@
>    <partintro>
>      <para>
>        This first part of the DRM Developer's Guide documents core DRM code,
> -      helper libraries for writting drivers and generic userspace interfaces
> +      helper libraries for writing drivers and generic userspace interfaces
>        exposed by DRM drivers.
>      </para>
>    </partintro>
> @@ -459,7 +459,7 @@ char *date;</synopsis>
>        providing a solution to every graphics memory-related problems, GEM
>        identified common code between drivers and created a support library to
>        share it. GEM has simpler initialization and execution requirements than
> -      TTM, but has no video RAM management capabitilies and is thus limited to
> +      TTM, but has no video RAM management capabilities and is thus limited to
>        UMA devices.
>      </para>
>      <sect2>
> @@ -889,7 +889,7 @@ int (*prime_fd_to_handle)(struct drm_device *dev,
>  	    vice versa. Drivers must use the kernel dma-buf buffer sharing framework
>  	    to manage the PRIME file descriptors. Similar to the mode setting
>  	    API PRIME is agnostic to the underlying buffer object manager, as
> -	    long as handles are 32bit unsinged integers.
> +	    long as handles are 32bit unsigned integers.
>  	  </para>
>  	  <para>
>  	    While non-GEM drivers must implement the operations themselves, GEM
> @@ -2351,7 +2351,7 @@ void intel_crt_init(struct drm_device *dev)
>        first create properties and then create and associate individual instances
>        of those properties to objects. A property can be instantiated multiple
>        times and associated with different objects. Values are stored in property
> -      instances, and all other property information are stored in the propery
> +      instances, and all other property information are stored in the property
>        and shared between all instances of the property.
>      </para>
>      <para>
> @@ -2692,10 +2692,10 @@ int num_ioctls;</synopsis>
>    <sect1>
>      <title>Legacy Support Code</title>
>      <para>
> -      The section very brievely covers some of the old legacy support code which
> +      The section very briefly covers some of the old legacy support code which
>        is only used by old DRM drivers which have done a so-called shadow-attach
>        to the underlying device instead of registering as a real driver. This
> -      also includes some of the old generic buffer mangement and command
> +      also includes some of the old generic buffer management and command
>        submission code. Do not use any of this in new and modern drivers.
>      </para>
>  
> 


-- 
~Randy
