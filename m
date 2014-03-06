Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaCFP0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:26:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42574 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752605AbaCFP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:26:31 -0500
Date: Thu, 6 Mar 2014 10:26:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valentina Manea <valentina.manea.m@gmail.com>
cc: gregkh@linuxfoundation.org, <ly80toro@cip.cs.fau.de>,
        <ke42caxa@cip.cs.fau.de>, <eladwexler77@yahoo.com>,
        <oat.elena@gmail.com>, <josh@joshtriplett.org>, <himangi774@gmail.com>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <andy.grover@gmail.com>,
        <firefly@lists.rosedu.org>
Subject: Re: [PATCH v2] staging: usbip: claim ports used by shared devices
In-Reply-To: <1394086144-13864-1-git-send-email-valentina.manea.m@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403061025580.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Valentina Manea wrote:

> A device should not be able to be used concurrently both by
> the server and the client. Claiming the port used by the
> shared device ensures no interface drivers bind to it and
> that it is not usable from the server.
> 
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
> ---
> Changes since v1:
> * add commit description
> * move struct dev_state definition back to usb/core/devio.c

For the changes to the USB core:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

