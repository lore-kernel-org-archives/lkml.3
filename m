Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3BZLis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:38:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58796 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BZLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:38:46 -0500
Date: Tue, 26 Feb 2013 06:38:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Heasley, Seth" <seth.heasley@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: Re: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Message-ID: <20130226113836.GA20780@hmsreliant.think-freely.org>
References: <1361485843-13560-1-git-send-email-seth.heasley@intel.com>
 <20130221213714.GB32764@hmsreliant.think-freely.org>
 <DEC3922D1904474A8862C7BFF516EA9A7115E094@ORSMSX101.amr.corp.intel.com>
 <20130221232615.GA3046@neilslaptop.think-freely.org>
 <DEC3922D1904474A8862C7BFF516EA9A7115EA33@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEC3922D1904474A8862C7BFF516EA9A7115EA33@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:08:35AM +0000, Heasley, Seth wrote:
> >> The difference here is that the S1200 name is already publicly released,
> >whereas the naming for Avoton hasn't been announced.
> >>
> >Do you know when the announcement will be?  Is it sufficiently soon that we
> >can just wait for it?
> 
> I don't, and actually couldn't tell you if I did.  The codename usage is consistent with how we deal with all products since the patches have to go in well in advance of product launch.
> 
Meh, ok, I guess we cal always fix it up when the product has an actual name

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> -Seth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
