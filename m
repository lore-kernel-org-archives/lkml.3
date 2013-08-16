Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3HPWTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:19:23 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42034 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HPWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:19:21 -0400
Date: Fri, 16 Aug 2013 22:21:11 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816212110.GB2636@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <520CBEC6.8010400@kernel.org>
 <20130816100702.GD26895@linutronix.de>
 <520E0E22.4000403@kernel.org>
 <520E0307.70704@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E0307.70704@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 12:46:31PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/16/2013 01:33 PM, Jonathan Cameron wrote:
> > Ah, fixes-togreg is for this cycle, whereas new stuff like this needs
> > to go on the togreg branch.  Hence please rebase on the togreg branch
> > instead.
> 
> But he needs "iio: ti_am335x_adc: Fix wrong samples received on 1st
> read" from that branch. How should the rebase be done?
> 
> Sebastian
First line of cover letter had a note on this..

Should I send that particular fix along with the patch series 
so its applied cleanly in the togreg branch. 

And then during the merge window things magically happen to 
fix this situation?

Thanks
Zubair

