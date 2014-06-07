Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaFGWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:01:09 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36804 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGWBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:01:06 -0400
Date: Sun, 8 Jun 2014 02:01:02 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_vti: Fix 'ip tunnel add' with 'key' parameters
Message-Id: <20140608020102.df3f38cfea0ff8193ea6316a@qrator.net>
In-Reply-To: <53938A4A.9010105@cogentembedded.com>
References: <20140608012518.39affaff049874520ae5a0cc@qrator.net>
	<53938A4A.9010105@cogentembedded.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2014 01:55:22 +0400
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

>     Please surround & with spaces for consistency; this also would follow the 
> general kernel coding style.

> WBR, Sergei
> 

Okay, original code was without spaces, didn't want to break this, I will resend.
