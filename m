Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaHKO2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:28:24 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:51569 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaHKO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:28:22 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: of: Make OF_DYNAMIC user selectable
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140728093526.38d8e732@canb.auug.org.au>
References: <20140728093526.38d8e732@canb.auug.org.au>
Date: Mon, 11 Aug 2014 15:28:17 +0100
Message-Id: <20140811142817.87834C40932@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014 09:35:26 +1000, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
> 
> I noticed the subject commit in the devicetree tree in linux-next today.
> The commit message gives us no idea why we would want to make this
> change.  We already have lots of user selectable CONFIG_ options ... do
> we really need this one as well?

It was a mistake. That was a patch added for private testing that
accidentally made it out into my public tree. I'm not sending it to
Linus. Code depending on OF_DYNAMIC needs to select it.

g.

