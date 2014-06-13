Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaFMQGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:06:32 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38081 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaFMQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
	<cover.1402672110.git.d.kasatkin@samsung.com>
	<248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
	<CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
Date: Fri, 13 Jun 2014 19:06:29 +0300
Message-ID: <CACE9dm8AR_0S9gB13T_tydBcYtJEtXmEOc_GRx_Qtfbw+pKM2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2014 19:03, Ming Lei <ming.lei@canonical.com> wrote:
> On Fri, Jun 13, 2014 at 11:09 PM, Dmitry Kasatkin
> <d.kasatkin@samsung.com> wrote:
>> There is no need to read attr because inode structure contains size
>> of the file. Use i_size_read() instead.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>
> Acked-by: Ming Lei <ming.lei@canonical.com>
>
>
> Thanks,
> --
> Ming Lei

Thanks.



-- 
Thanks,
Dmitry
