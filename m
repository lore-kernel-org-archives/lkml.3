Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3DSUlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:41:13 -0400
Received: from relay2.blacknight.com ([78.153.203.205]:41724 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3DSUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:41:12 -0400
Message-ID: <5171AC7D.70503@nexus-software.ie>
Date: Fri, 19 Apr 2013 21:43:41 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Josef Ahmad <josef.ahmad@linux.intel.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>, Stefan Roese <sr@denx.de>,
        Axel Lin <axel.lin@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
In-Reply-To: <alpine.DEB.2.02.1304191859570.17829@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef.

This fixes a real bug for us does it not, some failure case with a 
sustained amount of traffic ?


Bryan

