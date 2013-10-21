Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3JURXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:23:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42985 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751649Ab3JURXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:21 -0400
Date: Mon, 21 Oct 2013 13:23:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D65F419AE@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1310211321320.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013, Vishal Annapurve wrote:

> Hi,
> 
> Attaching the new patch which will replace all the occurrences of DID_ABORT
> with DID_TIMOUT in USB Storage whenever it sees US_FLIDX_TIMED_OUT bit
> is set.

It seems okay, but you forgot to update the isd200.c and
cypress_atacb.c files.

Also, in the future please put your patches inline with the rest of the 
email, not as a separate attachment.

Alan Stern

