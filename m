Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3CZXTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:19:45 -0400
Received: from 8bytes.org ([85.214.48.195]:46529 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab3CZXTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:19:43 -0400
Date: Wed, 27 Mar 2013 00:19:41 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Fix link error on ARM
Message-ID: <20130326231941.GE30540@8bytes.org>
References: <1364337232-3513-1-git-send-email-joro@8bytes.org>
 <20130326224536.GA29952@kroah.com>
 <20130326230359.GD30540@8bytes.org>
 <20130326230910.GA31021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326230910.GA31021@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 00:19:42 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51522d0e23671643012000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:09:10PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Mar 27, 2013 at 12:03:59AM +0100, Joerg Roedel wrote:

> Then should I just mark the driver as broken on ARM?

Well, at least ARM on SMP, for !SMP the missing function is defined and
will be inlined.

> Any reason for not including the driver authors on the Cc: for this
> patch?

I wasn't sure who the driver author is in the long list of persons from
the get_maintainer script. So it was more or less lazyness :)

Should I try to get that patch through the driver authors instead of
you?


	Joerg


