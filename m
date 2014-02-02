Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaBBBBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:01:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51189 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaBBBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:01:39 -0500
Date: Sat, 01 Feb 2014 17:01:38 -0800 (PST)
Message-Id: <20140201.170138.2222640901661791450.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 0/2] Drivers: net: hyperv: Cleanup the recive path 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391185478-5655-1-git-send-email-kys@microsoft.com>
References: <1391185478-5655-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 31 Jan 2014 08:24:38 -0800

> Some minor cleanup of the receive path. Get rid of unnecessary
> indirection as well as unnecessary re-establishment of state.

It is not appropriate to submit cleanups at this time.

Please wait until the net-next tree opens back up, and submit
your changes against it at that time.
