Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3CUEUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:20:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:55535 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3CUEUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:20:12 -0400
Message-ID: <1363839594.17680.19.camel@pasglop>
Subject: Re: [PATCH 2/2] of: remove /proc/device-tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 21 Mar 2013 05:19:54 +0100
In-Reply-To: <CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
	 <1363791074-16415-3-git-send-email-grant.likely@secretlab.ca>
	 <1363791479.12701.9.camel@pasglop>
	 <CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 21:38 +0000, Grant Likely wrote:
> > NAK. It should at the very least be a CONFIG option for a while
> before
> > completely switching over.
> 
> I'll modify patch 1 to create the symlink if CONFIG_PROC_DEVICETREE is
> not set. After the first patch can be applied we can leave it for a
> release or two before applying the second.

Shouldn't we have the symlink just be a config option itself ?
Eventually distros might want get rid of it completely ..

Ben.


