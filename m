Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaFYTJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:09:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaFYTJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:09:36 -0400
Date: Wed, 25 Jun 2014 21:09:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Johan Hovold <johan@kernel.org>
cc: Janne Kanniainen <janne.kanniainen@gmail.com>, greg@kroah.com,
        bjorn@mork.no, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R
 driver
In-Reply-To: <20140625174109.GE1409@localhost>
Message-ID: <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
References: <20140625115541.GA1409@localhost> <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com> <20140625174109.GE1409@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Johan Hovold wrote:

> Did you see the attribute-race series I posted? Not sure how best to
> handle the dependency, as those patches should probably go in through
> the LEDs tree, while the first patch in that series (adding the groups
> field) is a dependency for this patch.
> 
> Jiri, how would this best be solved?

I think the best course of action here is to gather Acks from the 
respective maintainers, and take the whole lot trough a single tree 
(probably the leds tree in this case) to avoid unnecessary intra-tree 
dependencies in a rather straighforward situation like this.

Thanks,

-- 
Jiri Kosina
SUSE Labs
