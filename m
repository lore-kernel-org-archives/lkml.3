Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaH3VYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:24:43 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:49293 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaH3VYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:24:42 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: migueloliv@gmail.com
In-Reply-To: <20140830204141.GD16168@kroah.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
	<1408703632-32286-1-git-send-email-cmroliv@gmail.com>
	<20140830204141.GD16168@kroah.com>
Date: Sat, 30 Aug 2014 23:24:41 +0200
X-Google-Sender-Auth: qGUu-MuW5vgcfxO4Eh02uFnf5jk
Message-ID: <CAMGgR5t-6ZZJxhR8i9iRWPGGrfegP2OMw1p29pT9EriZzdB3sw@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: rtl8188eu: rtw_debug.h
From: Miguel Oliveira <cmroliv@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> How does this change relate to what you said you were going to do above?
>
> confused,
>
That was a fix for a sparse warning that went on this patch acidenttly.
Sorry about that.
