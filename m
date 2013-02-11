Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3BKKZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:25:54 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38048 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3BKKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:25:52 -0500
Message-ID: <5118C72C.9060606@suse.cz>
Date: Mon, 11 Feb 2013 11:25:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Peter Hurley <peter@hurleysoftware.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org> <1360466060.3703.15.camel@thor.lan> <1360506199.3461.5.camel@thor.lan> <CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com> <CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
In-Reply-To: <CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 07:40 AM, Yinghai Lu wrote:
> Can you try attached debug patch?

FWIW this fixes it for me. No more 'derived' or 'nobody' in dmesg.

thanks,
-- 
js
suse labs
