Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561Ab3DDXvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:51:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33373 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765254Ab3DDXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130404160130.GA2577@udknight>
References: <20130404160130.GA2577@udknight>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Apr 2013 10:51:30 +1100
Message-ID: <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
Subject: Re: [PATCH] lib80211: make lib80211 can be enabled independently
To: Wang YanQing <udknight@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On Fri, Apr 5, 2013 at 3:01 AM, Wang YanQing <udknight@gmail.com> wrote:
>
> Current we can only enable lib80211 by enable a driver
> in tree use it which will select it, but some out tree's
> drivers also use it, so I think it has sense to make lib80211
> can be enabled independently.

Just as a bit of explanation for Johannes' NACK:

1. The only reason lib80211 still exists is because a couple of
in-tree drivers still use it. If this weren't the case, the code would
have been removed a long time ago as it's been completely replaced by
mac80211 and cfg80211. All modern drivers _must_ use mac80211 or
cfg80211 without exception.
2. In general, there is no official in-kernel support for
out-of-kernel drivers, regardless of quality, status or importance.
3. I believe that the in-tree brcmsmac driver already supports the
Broadcom card you reference.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
