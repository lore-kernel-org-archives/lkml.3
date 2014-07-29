Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaG2J6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:58:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaG2J6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:58:24 -0400
Date: Tue, 29 Jul 2014 11:58:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Patrick Plattes <patrick@erdbeere.net>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for jabra gn9350e (hid)
In-Reply-To: <1404543486-21080-1-git-send-email-patrick@erdbeere.net>
Message-ID: <alpine.LNX.2.00.1407291158120.16390@pobox.suse.cz>
References: <1404543486-21080-1-git-send-email-patrick@erdbeere.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2014, Patrick Plattes wrote:

> Ignore Jabra GN9350E HID interface. USB audio is working nicely,
> but registering as HID blocks USB mouse buttons. Since special userspace
> programs are needed we will avoid attaching usbhid drivers in general.

Applied.

-- 
Jiri Kosina
SUSE Labs
