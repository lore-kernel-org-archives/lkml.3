Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3BESaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:30:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40978 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3BESaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:30:10 -0500
Date: Tue, 5 Feb 2013 18:30:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130205183008.GA14451@srcf.ucam.org>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205181926.GA13942@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 06:19:26PM +0000, Matthew Garrett wrote:
> On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:
> 
> > Digitally signed initramfs can be used to provide protected user-space
> > environment for initialization purpose. For example, LSM, IMA/EVM can be
> > securely initialized using such approach.
> 
> What stops an attacker from simply removing the signed image from the 
> initramfs and running modified versions of the same tools from the 
> unsigned image?

I'm sorry, ignore that - if the kernel's configured to do this, it'll 
panic if it can't find the signed image. Ok.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
