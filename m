Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AVTM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:12:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55776 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3AVTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:12:55 -0500
Date: Tue, 22 Jan 2013 14:12:52 -0500 (EST)
Message-Id: <20130122.141252.781223481145097577.davem@davemloft.net>
To: keescook@chromium.org
Cc: chunkeey@googlemail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        linville@tuxdriver.com, kvalo@qca.qualcomm.com
Subject: Re: [PATCH 16/20] drivers/net/wireless/p54: remove depends on
 CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGXu5jJCQshUntUk7MeZds59B2fa54GnonOz28dM1x2spEEGDg@mail.gmail.com>
References: <1358879444-25834-17-git-send-email-keescook@chromium.org>
	<201301221937.16916.chunkeey@googlemail.com>
	<CAGXu5jJCQshUntUk7MeZds59B2fa54GnonOz28dM1x2spEEGDg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 22 Jan 2013 10:40:12 -0800

> On Tue, Jan 22, 2013 at 10:37 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>> Aren't these patches going through wireless-next
>> or linux-next?
> 
> They can go however it makes things easiest. Greg has offered to carry
> them in driver-core if Dave doesn't want to carry them in netdev.

Greg can take these:

Acked-by: David S. Miller <davem@davemloft.net>
