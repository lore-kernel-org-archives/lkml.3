Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3FGN40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:56:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50721 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3FGN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:56:24 -0400
Message-ID: <51B1E68C.1040504@cogentembedded.com>
Date: Fri, 07 Jun 2013 17:56:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lotfi Manseur <lotfi.manseur@gmail.com>
CC: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, Willy Tarreau <w@1wt.eu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
In-Reply-To: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/07/2013 05:14 PM, Lotfi Manseur wrote:

> Handle null termios in ftdi_set_termios(), introduced in
> commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
> This has been corrected in the mainline by
> commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
> a816e3113b63753c330ca4751ea1d208e93e3015.

    You should also give the summary lines of all mentioned commits in 
parens.

> This is to be fixed in longterm 2.6.32.60 and 3.4.47.
> This bug has been found with coccinelle.
>
> Signed-off-by: Lotfi Manseur <lotfi.manseur@imag.fr>
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

WBR, Sergei

