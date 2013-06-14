Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3FNWrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:47:14 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:48970 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3FNWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:47:12 -0400
Date: Fri, 14 Jun 2013 15:47:09 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] pstore/ram for 3.11
Message-ID: <20130614224708.GA15085@teo>
References: <51B9402C.5070300@gmail.com>
 <CA+8MBbKPr_y4rTBArcmz315y0f2-07Qu6DsM2cj-XW7-U=L56Q@mail.gmail.com>
 <51BB99F0.6030607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51BB99F0.6030607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 05:32:16PM -0500, Rob Herring wrote:
> https://lkml.org/lkml/2013/4/9/831
> 
> The main discussion was around the write-combining change which I
> dropped. You can pick patches 2 and 3 off the mail list if you prefer. I
> would assume they only require an ack from one of the 4 of you which
> pulling the tree implicitly does.

I've just re-reviewed the discussion. I see Colin was talking about ftrace
causing infinite loops due to recursion. Once I stumbled onto this too
(but the issue itself was due to missing 'notrace' mark), and Stephen told
that recursion protection is kind of mandatory:

  http://lists.linaro.org/pipermail/linaro-kernel/2012-August/002084.html

I belive that the protection is actually there nowadays, and that is why
Rob does not see the problem with his patch.

So, I guess the patches are good, at least they fix real issues for Rob.
:)

	Acked-by: Anton Vorontsov <anton@enomsg.org>

(Or I can pick this via linux-pstore.git tree, I'll let Tony decide.)

Thanks!

Anton
