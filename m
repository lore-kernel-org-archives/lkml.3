Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3GJMPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab3GJMO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:14:58 -0400
Date: Wed, 10 Jul 2013 15:16:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio tools: add .gitignore
Message-ID: <20130710121609.GC11386@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
 <1373453820-22517-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373453820-22517-3-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:27:00PM +0530, Ramkumar Ramachandra wrote:
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---

Why not.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

>  tools/virtio/.gitignore | 3 +++
>  1 file changed, 3 insertions(+)
>  create mode 100644 tools/virtio/.gitignore
> 
> diff --git a/tools/virtio/.gitignore b/tools/virtio/.gitignore
> new file mode 100644
> index 0000000..1cfbb01
> --- /dev/null
> +++ b/tools/virtio/.gitignore
> @@ -0,0 +1,3 @@
> +*.d
> +virtio_test
> +vringh_test
> -- 
> 1.8.3.2.736.g869de25
