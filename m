Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3DMVBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 17:01:25 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3DMVBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 17:01:23 -0400
Message-ID: <1365886878.1089.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 13 Apr 2013 23:01:18 +0200
In-Reply-To: <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20130413_161415_789566_66E15F78)
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130413_161415_789566_66E15F78)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 07:13 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> This backports the latest regulator drivers for kernels >= 3.4.
> We enable the regulator only on kernels >= 3.4 given that
> it relies on the new probe deferral mechanism which would
> otherwise mean having to support drivers that do not probe
> correctly. Note that 3.2 had a base regulator implementation
> but that was just stubs.

Applied.

johannes

