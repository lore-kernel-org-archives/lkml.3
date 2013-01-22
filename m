Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3AVTP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:15:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47138 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3AVTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:15:26 -0500
Date: Tue, 22 Jan 2013 14:14:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: keescook@chromium.org, chunkeey@googlemail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, kvalo@qca.qualcomm.com
Subject: Re: [PATCH 16/20] drivers/net/wireless/p54: remove depends on
 CONFIG_EXPERIMENTAL
Message-ID: <20130122191408.GC13719@tuxdriver.com>
References: <1358879444-25834-17-git-send-email-keescook@chromium.org>
 <201301221937.16916.chunkeey@googlemail.com>
 <CAGXu5jJCQshUntUk7MeZds59B2fa54GnonOz28dM1x2spEEGDg@mail.gmail.com>
 <20130122.141252.781223481145097577.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122.141252.781223481145097577.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 02:12:52PM -0500, David Miller wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Tue, 22 Jan 2013 10:40:12 -0800
> 
> > On Tue, Jan 22, 2013 at 10:37 AM, Christian Lamparter
> > <chunkeey@googlemail.com> wrote:
> >> Aren't these patches going through wireless-next
> >> or linux-next?
> > 
> > They can go however it makes things easiest. Greg has offered to carry
> > them in driver-core if Dave doesn't want to carry them in netdev.
> 
> Greg can take these:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
