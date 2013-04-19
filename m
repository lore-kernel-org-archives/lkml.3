Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab3DSVVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:21:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:40478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3DSVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,512,1363158000"; 
   d="scan'208";a="321090470"
Message-ID: <54738.10.252.10.81.1366406459.squirrel@linux.intel.com>
In-Reply-To: <5171AC7D.70503@nexus-software.ie>
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
    <5171AC7D.70503@nexus-software.ie>
Date: Fri, 19 Apr 2013 14:20:59 -0700 (PDT)
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
From: "Josef Ahmad" <josef.ahmad@linux.intel.com>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: "Josef Ahmad" <josef.ahmad@linux.intel.com>,
        "Wolfram Sang" <wsa@the-dreams.de>, "Ben Dooks" <ben-linux@fluff.org>,
        "Jean Delvare" <khali@linux-fr.org>, "Stefan Roese" <sr@denx.de>,
        "Axel Lin" <axel.lin@gmail.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dirk Brandewie" <dirk.brandewie@gmail.com>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does.
The bug appears with fairly-sized read transactions (in the order of kB)
returning corrupted data.

Josef

> Josef.
>
> This fixes a real bug for us does it not, some failure case with a
> sustained amount of traffic ?
>
>
> Bryan
>
>

