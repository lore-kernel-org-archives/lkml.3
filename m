Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbaDIOD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:03:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933660AbaDIODZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:03:25 -0400
Date: Wed, 9 Apr 2014 16:03:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: introduce RMI driver for Synaptics touchpads
In-Reply-To: <1396892373-3330-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1404091603110.14588@pobox.suse.cz>
References: <1396892373-3330-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014, Benjamin Tissoires wrote:

> This driver add support for RMI4 over USB or I2C.
> The current state is that it uses its own RMI4 implementation, but once
> RMI4 is merged upstream, the driver will be a transport driver for the
> RMI4 library.

Queuing for 3.16, thanks.

-- 
Jiri Kosina
SUSE Labs
