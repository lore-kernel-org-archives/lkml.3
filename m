Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJFH4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:56:08 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:57664 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaJFH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:56:03 -0400
Date: Mon, 6 Oct 2014 09:55:56 +0200
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw1.se.axis.com
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: open list <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
In-Reply-To: <1412353168.10105.5.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1410060954360.17221@lnxricardw1.se.axis.com>
References: <1412089998-18978-1-git-send-email-tlinder@codeaurora.org> <1412350035.3795.101.camel@sauron.fi.intel.com> <CACna6ryws=d_7NXhzWyu34TaV+Yv8y0+D4Q0ewuzDEv=8xDxRg@mail.gmail.com> <1412353168.10105.5.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2014, Artem Bityutskiy wrote:

> I respect checkpatch.pl, and uniformity / consistency, but in this
> particular case I put my maintainer hat on and say that for this kernel
> subsystem it is fine, because the maintainer will be more efficient in
> maintaining this code when the code is a bit mere readable for him.

I believe checkpatch.pl flags long lines as a warning, not as an error, 
indicating some relaxation on the severity to start with.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
