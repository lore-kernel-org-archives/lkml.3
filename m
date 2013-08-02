Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3HBQXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:23:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50540 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548Ab3HBQXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:23:24 -0400
Message-ID: <1375460603.2034.119.camel@joe-AO722>
Subject: Re: [PATCH] Tweak Documentation MAINTAINERS entry.
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 09:23:23 -0700
In-Reply-To: <1375459978.687125@landley.net>
References: <1375459978.687125@landley.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 09:13 -0700, Rob Landley wrote:
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -2664,6 +2664,10 @@ L:	linux-doc@vger.kernel.org
>  T:	TBD
>  S:	Maintained
>  F:	Documentation/
> +X:	Documentation/zh_CN
> +X:	Documentation/ko_KR
> +X:	Documentation/ja_JP
> +X:	Documentation/devicetree/bindings

Please add terminating slashes to those
X entries to make it clear those are
directories.


