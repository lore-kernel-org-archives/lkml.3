Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3KNVAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:00:51 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58011 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3KNVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:00:42 -0500
Date: Thu, 14 Nov 2013 21:00:15 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.ernst@linux.intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 3/3] ipc: Added support for IPC interrupt mode
Message-ID: <20131114210015.25dab122@alan.etchedpixels.co.uk>
In-Reply-To: <52850A12.3090900@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
	<1384373671-12814-4-git-send-email-david.a.cohen@linux.intel.com>
	<20131114134842.7225c7f8@alan.etchedpixels.co.uk>
	<52850A12.3090900@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 09:36:18 -0800
David Cohen <david.a.cohen@linux.intel.com> wrote:

> Hi Alan,
> 
> [snip]
> 
> > So I think
> >
> > 1. Pass the informatio upon whether IRQ mode should be used in the
> > platform information and remove all the ifdeffery
> 
> I will double check with Sathya. But in case polling mode is left for
> development purpose, make we can create a static variable to set irq
> mode or not.

If its only for development it doesn't IMHO need to be upstream. If its
useful for debug and/or needed on real chipsets (as I believe is the case
for the older ones) then a module (and thus kernel command line) option
would be sensible yes.
