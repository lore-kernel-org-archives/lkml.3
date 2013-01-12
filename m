Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3ALBoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:44:37 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52091 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3ALBog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Xd6ATWO_1zOcg97sXcnabKBHjrHFetbfGRbDL-x1gqxw@mail.gmail.com>
References: <CAB=NE6Xd6ATWO_1zOcg97sXcnabKBHjrHFetbfGRbDL-x1gqxw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 11 Jan 2013 17:44:14 -0800
X-Google-Sender-Auth: Z4MH8wNLMEozD4kB2mSmc3eu6yg
Message-ID: <CAB=NE6V4nSkYGFiKKSb1cQJMXqftOxguL+Zrq=-oDvipshBm2A@mail.gmail.com>
Subject: Re: rel-html: HTML5 release page for compat-drivers, maybe kernel.org
 and others
To: Konstantin Ryabitsev <mricon@kernel.org>, backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 6:37 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> I've created a Python release script called rel-html [0] to
> generate a simple HTML5 page based on the initializr project for a
> base HTML5 template [0].
>
> [0] https://github.com/mcgrof/rel-html

Example release pages:

  * http://drvbp1.linux-foundation.org/~mcgrof/rel-html/linux/
  * http://drvbp1.linux-foundation.org/~mcgrof/rel-html/compat-drivers/
  * http://drvbp1.linux-foundation.org/~mcgrof/rel-html/iw/
  * http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/
  * http://drvbp1.linux-foundation.org/~mcgrof/rel-html/hostapd/

Now with full paths for the URLs instead of relative.

  Luis
