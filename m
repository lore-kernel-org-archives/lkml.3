Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab3CMTRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:17:37 -0400
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:44510
	"EHLO qmta09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934110Ab3CMTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:17:35 -0400
Date: Wed, 13 Mar 2013 15:17:29 -0400
From: Frank Peters <frank.peters@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB Mouse Disconnect Kernel-3.7/3.8
Message-Id: <20130313151729.7a173a680ee2e347352a3e5b@comcast.net>
In-Reply-To: <alpine.LRH.2.00.1303131644570.27467@twin.jikos.cz>
References: <20130311142651.12cc0311887f69db13913986@comcast.net>
	<alpine.LRH.2.00.1303131644570.27467@twin.jikos.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.16; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 16:45:35 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> 
> Do you have USB autosuspend enabled on that device?
> 

The CONFIG_USB_SUSPEND, which controls USB autosuspend, is not available
to me during kernel configuration because I do not enable "Run-time PM core
functionality" (PM_RUNTIME).

Based on this, I would assume that USB autosuspend is not enabled.

Frank Peters

