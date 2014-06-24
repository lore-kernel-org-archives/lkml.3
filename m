Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaFXSXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:23:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45500 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752599AbaFXSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:23:21 -0400
Date: Tue, 24 Jun 2014 14:23:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael Marineau <mike@marineau.org>, Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: CONFIG_UEVENT_HELPER default
Message-ID: <Pine.LNX.4.44L0.1406241421050.888-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael and Greg:

The help text for CONFIG_UEVENT_HELPER says (among other things):

	  This should not be used today, because usual systems create
	  many events at bootup or device discovery in a very short time
	  frame.

If it shouldn't be used, why does it default to 'y'?

Alan Stern

