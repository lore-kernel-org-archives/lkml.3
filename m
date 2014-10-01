Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaJAVmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:42:31 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:43984 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJAVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:42:30 -0400
Date: Thu, 2 Oct 2014 00:42:21 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        gulsah.1004@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        cmroliv@gmail.com
Subject: Re: [PATCH] staging: nokia_h4: remove deprecated IRQF_DISABLED
Message-ID: <20141001214221.GF26954@drone.musicnaut.iki.fi>
References: <1412195628-9522-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412195628-9522-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 01, 2014 at 10:33:48PM +0200, Michael Opdenacker wrote:
> Remove the use of the IRQF_DISABLED flag
> from drivers/staging/nokia_h4p/nokia_core.c
> 
> It's a NOOP since 2.6.35 and it will be removed soon.

This driver has been deleted from the staging tree already.

A.
