Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3BUX03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:26:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38460 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3BUX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:26:27 -0500
Date: Thu, 21 Feb 2013 18:26:15 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Heasley, Seth" <seth.heasley@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: Re: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Message-ID: <20130221232615.GA3046@neilslaptop.think-freely.org>
References: <1361485843-13560-1-git-send-email-seth.heasley@intel.com>
 <20130221213714.GB32764@hmsreliant.think-freely.org>
 <DEC3922D1904474A8862C7BFF516EA9A7115E094@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEC3922D1904474A8862C7BFF516EA9A7115E094@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:19:48PM +0000, Heasley, Seth wrote:
> Hi Neil,
> 
> >> This patch adds the iSMT SMBus Controller DeviceIDs for the Intel Avoton
> >SOC.
> >>
> >> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> >Is there a part number (I.e. S1200) that we can use in the name, rather than
> >the project code name?  That would seem to be more in keeping with the
> >previous naming scheeme directly above it Neil
> 
> The difference here is that the S1200 name is already publicly released, whereas the naming for Avoton hasn't been announced.  
> 
Do you know when the announcement will be?  Is it sufficiently soon that we can
just wait for it?

Neil

> Regards,
> -Seth
> 
