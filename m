Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaCRBlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:41:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45122 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaCRBlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:41:50 -0400
Date: Mon, 17 Mar 2014 21:41:48 -0400 (EDT)
Message-Id: <20140317.214148.2254695408331774828.davem@davemloft.net>
To: benchan@chromium.org
Cc: bjorn@mork.no, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org, gregkh@linuxfoundation.org,
        gsuarez@smithmicro.com
Subject: Re: [PATCH 2/2] net: cdc_ncm: respect operator preferred MTU
 reported by MBIM
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC5Y2nMdPM8w3=dgd2as5z8huL1XLPjon8wSmR-2e3=JGWtCpA@mail.gmail.com>
References: <CAC5Y2nN_w46FczgitbPjmXtk7q3rHpTxLddx0_GtStfzNXerXQ@mail.gmail.com>
	<87d2hkldmx.fsf@nemi.mork.no>
	<CAC5Y2nMdPM8w3=dgd2as5z8huL1XLPjon8wSmR-2e3=JGWtCpA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 18:41:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>
Date: Mon, 17 Mar 2014 17:46:27 -0700

> Thanks again for the review and tip. I've submitted patch v2 to
> address the le16_to_cpu conversion.

When you update a patch from a series, you should repost the entire
patch set, rather than just the patch which changes.

This avoids any and all ambiguity of which patches go with which
others.
