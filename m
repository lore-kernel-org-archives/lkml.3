Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3J2UVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:21:42 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:53217 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3J2UVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:21:39 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: [PATCH v3] dynamic_debug: add wildcard support to filter files/functions/modules
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1383053609-2895-1-git-send-email-changbin.du@gmail.com>
Date: Tue, 29 Oct 2013 21:21:28 +0100
Cc: jbaron@akamai.com, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8F7F1A3C-949F-4718-9FD5-E35C1B78E1D9@holtmann.org>
References: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com> <1383053609-2895-1-git-send-email-changbin.du@gmail.com>
To: "Du, Changbin" <changbin.du@gmail.com>
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changbin,

> This patch add wildcard '*'(matches zero or more characters) and '?'
> (matches one character) support when qurying debug flags.
> 
> Now we can open debug messages using keywords. eg:
> 1. open debug logs in all usb drivers
>    echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
> 2.  open debug logs for usb xhci code
>    echo "file *xhci* +p" > <debugfs>/dynamic_debug/control

and this should have a section in Documentation/dynamic-debug-howto.txt.

Regards

Marcel

