Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaJWUMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:12:35 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:64389 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJWUMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:12:34 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 16:12:33 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21577.23715.373456.525742@quad.stoffel.home>
Date: Thu, 23 Oct 2014 15:53:07 -0400
From: "John Stoffel" <john@stoffel.org>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hector Martin <hector@marcansoft.com>
Subject: Re: [PATCH v2] usb: serial: Perform verification for FTDI FT232R devices
In-Reply-To: <1414093301-21992-1-git-send-email-Russ.Dill@gmail.com>
References: <5449355C.2060301@marcansoft.com>
	<1414093301-21992-1-git-send-email-Russ.Dill@gmail.com>
X-Mailer: VM 8.2.0b under 23.4.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So what else is in those magic 2.12.00 official drivers besides this
eeprom magic?  And why don't you printer a much more informative
message to the logs when you do fail a chip?  

No matter what you say here, you're targetting end users with this
patch, even if you're just trying to put pressure on the vendors
making knock off copies of the chip.  Which isn't good, but I know who
I'd be mad at if this bricked my USB to serial cable in the name of
vendor chip purity.  

John
