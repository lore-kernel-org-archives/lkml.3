Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3HMTC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:02:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:02:55 -0400
Date: Tue, 13 Aug 2013 20:02:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
Message-ID: <20130813190233.GB25647@n2100.arm.linux.org.uk>
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com> <20130813182012.GE7740@kroah.com> <70F17005-652E-4C04-B6EC-51E16EE237C3@antoniou-consulting.com> <20130813185521.GA9483@kroah.com> <DB915540-70CB-4600-BF8D-734107B1FE29@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB915540-70CB-4600-BF8D-734107B1FE29@antoniou-consulting.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:59:03PM +0300, Pantelis Antoniou wrote:
> Hi Greg,
> 
> Just to make sure we're on the same page this is with my platform device
> removal patchset applied.
> 
> Without it you get the original crash I've posted in the pdevtest patch with
> the unbind method.

Yes, congratulations, you've found a bug in the way OMAP uses the runtime
PM stuff in this driver.  That bug needs to be fixed irrespective of
anything else.
