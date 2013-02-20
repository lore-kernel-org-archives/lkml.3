Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3BTRxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:53:22 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:47859 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055Ab3BTRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:53:17 -0500
Message-ID: <51250D89.9020401@kernel.org>
Date: Wed, 20 Feb 2013 12:53:13 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 05/16] blackfin idle: delete pm_idle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <8408629d64626937a5202751703dae7f41941f7a.1360475150.git.len.brown@intel.com> <512256A3.6050100@metafoo.de>
In-Reply-To: <512256A3.6050100@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Otherwise the patch seems to work fine.

Thanks for testing Lars!
Sorry about breaking the build w/ my slopyness --
will get that patched up.

cheers,
Len Brown, Intel Open Source Technology Center

