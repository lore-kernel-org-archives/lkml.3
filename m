Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbaGBBdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:33:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaGBBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACE9dm9bSLTMuaobgZNF+Xe7GxZZKjqedK91PsTjYrJWafMGiw@mail.gmail.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
	<cover.1402672110.git.d.kasatkin@samsung.com>
	<248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
	<CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
	<CACE9dm8AR_0S9gB13T_tydBcYtJEtXmEOc_GRx_Qtfbw+pKM2w@mail.gmail.com>
	<CACE9dm9bSLTMuaobgZNF+Xe7GxZZKjqedK91PsTjYrJWafMGiw@mail.gmail.com>
Date: Wed, 2 Jul 2014 09:33:49 +0800
Message-ID: <CACVXFVPYVXe8LXtG4L4yjzLJWoT-mhuDKRkurNmsk5W-Qq4dxQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
From: Ming Lei <ming.lei@canonical.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:46 AM, Dmitry Kasatkin
<dmitry.kasatkin@gmail.com> wrote:
> On 13 June 2014 19:06, Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
>> On 13 June 2014 19:03, Ming Lei <ming.lei@canonical.com> wrote:
>>> On Fri, Jun 13, 2014 at 11:09 PM, Dmitry Kasatkin
>>> <d.kasatkin@samsung.com> wrote:
>>>> There is no need to read attr because inode structure contains size
>>>> of the file. Use i_size_read() instead.
>>>>
>>>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>>
>>> Acked-by: Ming Lei <ming.lei@canonical.com>
>>>
>
>
> Hi,
>
> BTW. To what tree it is applied?

Greg will take it in driver-core tree.

Thanks,
--
Ming Lei
