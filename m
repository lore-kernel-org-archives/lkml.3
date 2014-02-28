Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaB1KiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:38:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaB1KiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:38:20 -0500
Message-ID: <1393582795.3364.5.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v5 0/2] hyperv-fb: add support for generation 2 virtual
 machines
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kys@microsoft.com, abgupta@microsoft.com,
        haiyangz@microsoft.com, jasowang@redhat.com,
        devel@linuxdriverproject.org
Date: Fri, 28 Feb 2014 11:19:55 +0100
In-Reply-To: <53105077.4090102@ti.com>
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
	 <53105077.4090102@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 2014-02-28 at 11:01 +0200, Tomi Valkeinen wrote:
> On 26/02/14 12:51, Gerd Hoffmann wrote:
> >   Hi,
> > 
> > This patch series adds support for uefi-based gen2 virtual machines
> > to the hyperv-fb driver.  It depends on a few vmbus changes which are
> > staged in Greg's char-misc tree (and linux-next).
> 
> Depends how?

Will fail to build without the vmbus patches.

> Patches that depend on other patches should be merged via
> the same tree to avoid compile or functional breaks.

I think Greg will happily merge them through char-misc if he gets your
fbdev maintainer ACK for the patches.

cheers,
  Gerd


