Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaE0OmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:42:08 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:34134 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaE0OmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:42:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2014 16:42:02 +0200
From: Bernhard Walle <bernhard@bwalle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org
Subject: RE: Regression in hyperv network driver in 3.14
In-Reply-To: <25b90b45e3284715ab0ab00cb812a99f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140527111003.GA2214@kepler.fritz.box>
 <25b90b45e3284715ab0ab00cb812a99f@BY2PR03MB299.namprd03.prod.outlook.com>
Message-ID: <4370df7be3d8c3e6d53dad487527b234@bwalle.de>
User-Agent: Roundcube Webmail
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-05-27 15:43, schrieb KY Srinivasan:

>> Can I provide more information to track down the problem?
> 
> This bug has been fixed upstream. The issue is with regards to the
> older hosts (ws2008 r2) not
> Being able to handle the larger receive buffer currently used.

Can you point me to the commit that fixed the problem? Woudln't that
be something for -stable since the problem is still in 3.14.4.


Regards,
Bernhard

