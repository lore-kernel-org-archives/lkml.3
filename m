Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3LZSZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:25:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:56962 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752954Ab3LZSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:25:28 -0500
Date: Thu, 26 Dec 2013 13:25:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A31B4E@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1312261324390.24521-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Du, ChangbinX wrote:

> I can reproduce issue by adding a delay just after usb_set_intfdata(intf, NULL)
>  (echo -1 > bConfigurationValue to trigger hub_dissconnect())without your patch.
> 
> After patch applied, cannot reproduce and didn't found any other issue. Patch works well.
> 
> Alan, need I update patch to v2 or you will do it?

I will send in the updated patch next week, after I get back from 
vacation.

Alan Stern

