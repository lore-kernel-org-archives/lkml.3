Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3F1OoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:44:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3F1On7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:43:59 -0400
Date: Fri, 28 Jun 2013 16:46:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'John W. Linville'" <linville@tuxdriver.com>, cpgs@samsung.com
Subject: Re: [PATCH 3.9-stable]  iwlegacy: fix rate control regression
Message-ID: <20130628144626.GA1580@redhat.com>
References: <002401ce7390$2aebe2b0$80c3a810$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002401ce7390$2aebe2b0$80c3a810$%choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 08:43:46AM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

No, this regression is caused by

commit 0d528d85c519b755b6f4e1bafa3a39984370e1c1
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Mon Apr 22 16:14:41 2013 +0200

    mac80211: improve the rate control API

which first appear on 3.10-rc2. Sorry for not specifying that information
in the ChangeLog.

Stanislaw

