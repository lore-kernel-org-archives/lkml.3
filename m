Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3DVI4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:56:23 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:65273 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3DVI4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:56:21 -0400
Date: Mon, 22 Apr 2013 10:56:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "George G. Davis" <gdavis@mvista.com>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Vincent Sanders <vince@collabora.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
Message-ID: <20130422085619.GA9393@merkur.ravnborg.org>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk> <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk> <20120528203005.GA20560@merkur.ravnborg.org> <20120529090614.GD12217@n2100.arm.linux.org.uk> <20120606101253.GM8262@n2100.arm.linux.org.uk> <87F2CC87-0FAF-49CB-AE70-423FB063A0E5@mvista.com> <20130401215834.GA5972@merkur.ravnborg.org> <CAE1uF8dCy3m3TO4xa6Cc3i-CM3QYUFADZH_6o+hgy6MSPEWnyQ@mail.gmail.com> <20130418123931.GR14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418123931.GR14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:39:31PM +0100, Russell King - ARM Linux wrote:
> Looks to me like this has died again.  Unless Sam responds shortly,
> I'm going to ask for this to be put into the patch system and I'll
> just apply it for 3.10 and be done with it.

I had preferred it was a solution where we supported both
variants in the code.
But I do not feel strongly about it.

So you can add my ack and apply it.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
