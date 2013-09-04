Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046Ab3IDRjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:39:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:53173 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3IDRjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:39:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r7Rwb0vUtI=
X-RZG-CLASS-ID: mo00
Date: Wed, 4 Sep 2013 19:39:13 +0200
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Message-ID: <20130904173913.GA29061@aepfle.de>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
 <20130904135754.GA2010@aepfle.de>
 <20130904150648.GA9162@aepfle.de>
 <615470dba26b432fa041a02678395e2c@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <615470dba26b432fa041a02678395e2c@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, KY Srinivasan wrote:

> Thanks Olaf. I would prefer that we explicitly fail the negotiations than assume that it will succeed.
> Essentially, I want the same behavior as what we had before but only for the final version being
> negotiated. If it is ok with you, I can spin up the patch and send it out.

Sure, whatever works.

Olaf
