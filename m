Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3F1OWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:22:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56964 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755181Ab3F1OWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:22:34 -0400
Date: Fri, 28 Jun 2013 10:22:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Li, Zhen-Hua (USL-China)" <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
In-Reply-To: <51CCE13F.6070009@hp.com>
Message-ID: <Pine.LNX.4.44L0.1306281018001.1047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Li, Zhen-Hua (USL-China) wrote:

> There was a problem, the warning "Controller not stopped yet".
> And your last patch for this problem does a wrong thing:
> It prevents all HP uhci devices from auto-stop, which make HP uhci 
> devices waste more
> power.

Do they really waste more power?  Have you measured this?

Is CONFIG_PM enabled in the kernel configuration?

> This is another new problem.
> 
> I think this should be corrected, so I want to apply it.

In the last email, you said that your patch did not make the machine
act different.  Now you say that your patch makes the machine use less
power.  Which statement is correct?

Alan Stern

