Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaFMQDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:03:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaFMQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
	<cover.1402672110.git.d.kasatkin@samsung.com>
	<248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
Date: Sat, 14 Jun 2014 00:03:10 +0800
Message-ID: <CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
From: Ming Lei <ming.lei@canonical.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:09 PM, Dmitry Kasatkin
<d.kasatkin@samsung.com> wrote:
> There is no need to read attr because inode structure contains size
> of the file. Use i_size_read() instead.
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Acked-by: Ming Lei <ming.lei@canonical.com>


Thanks,
--
Ming Lei
