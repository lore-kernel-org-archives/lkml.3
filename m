Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3ARPsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:48:06 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:59890 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab3ARPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:48:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAG6Zu08Y1KFE/2dsb2JhbAANN4F7gzKrG4ZmAQEBAQMjVQEQCw4KAgIFFgsCAgkDAgECAUUGDQEHAQGvGJJ7gSaOCoEUA4hClXeJWQ
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="212872019"
Message-ID: <50F96EB2.3090605@teksavvy.com>
Date: Fri, 18 Jan 2013 10:48:02 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG at net/sunrpc/svc_xprt.c:921
References: <50F42F85.50907@teksavvy.com> <20130114203711.GA29982@fieldses.org> <50F4D800.5040703@teksavvy.com> <20130115205625.GH4940@fieldses.org> <50F63882.8000607@parallels.com> <50F72F03.5070806@teksavvy.com> <50F786AF.4070107@parallels.com> <20130117130335.GD6598@fieldses.org> <50F7FB7E.2020503@parallels.com> <50F88C14.7030903@teksavvy.com> <50F8DF7E.8080107@parallels.com>
In-Reply-To: <50F8DF7E.8080107@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-01-18 12:37 AM, Stanislav Kinsbursky wrote:
>
> You have more than one NFS mount in different network namespaces, haven't you?
>

No, I don't (knowingly) use (multiple) namespaces at all.
Usually I disable them in the kernel .config,
though it appears the currently running kernel has this:

CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set

The full .config was attached to the first post in this thread.

Cheers

