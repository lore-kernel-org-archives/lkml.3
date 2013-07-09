Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3GIEM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:12:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39247 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3GIEMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:12:24 -0400
X-Sasl-enc: VzzO1D0po3/fuP+79HIwDJSrhF99UFGZAzo2axnFOhQy 1373343143
Date: Mon, 8 Jul 2013 21:13:21 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, joe.lawrence@stratus.com,
        myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709041321.GA30555@kroah.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709012611.GA22371@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:26:11AM +0200, Pavel Machek wrote:
> Hi!
> 
> My thinkpad has rather high ping latencies... and perhaps it is due to
> PCIE ASPM.

Why would that be the problem?  The odds that the PCIE bus is the issue
seems strange to me.

greg k-h
