Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaAAW7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 17:59:40 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55822 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaAAW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 17:59:39 -0500
Message-ID: <52C1DDBF.4010907@gmail.com>
Date: Tue, 31 Dec 2013 09:55:27 +1300
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dongsheng Song <dongsheng.song@gmail.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: man-pages-3.55 is released
References: <52C14889.7000700@gmail.com> <CAE8XmWosaRDW=AOtbC0d_GAquPtzEZq7M4TgwzMNQUx_uz8HSQ@mail.gmail.com>
In-Reply-To: <CAE8XmWosaRDW=AOtbC0d_GAquPtzEZq7M4TgwzMNQUx_uz8HSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/13 01:41, Dongsheng Song wrote:
> Hi,
> 
> Excerpt from http://man7.org/linux/man-pages/man2/socket.2.html :
> 
>        Some socket types may not be implemented by all protocol families;
>        for example, SOCK_SEQPACKET is not implemented for AF_INET.
> 
> This is not correct now, as Linux already had SCTP support.
> 
> Excerpt from http://tools.ietf.org/html/rfc6458#section-3.1.1 :
> 
>    and one uses PF_INET or PF_INET6 as the domain, SOCK_SEQPACKET as the
>    type, and IPPROTO_SCTP as the protocol.
> 
>    Here, SOCK_SEQPACKET indicates the creation of a one-to-many style
>    socket.
> 
> Regards,
> Dongsheng

Hello Dongsheng,

Thanks for the report. I've updated the page to remove that 
crufty text:

>        for example, SOCK_SEQPACKET is not implemented for AF_INET.

For the future, bugs are best reported in a new subject
line; see https://www.kernel.org/doc/man-pages/reporting_bugs.html
Cheers,

Michael




