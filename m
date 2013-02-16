Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3BPQQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 11:16:38 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43274 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3BPQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 11:16:36 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, monstr@monstr.eu, arnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tty: serial: uartlite: Support uartlite on big and little endian systems
References: <1360605874-18310-1-git-send-email-michal.simek@xilinx.com>
	<1360605874-18310-2-git-send-email-michal.simek@xilinx.com>
Date: Sat, 16 Feb 2013 17:16:26 +0100
In-Reply-To: <1360605874-18310-2-git-send-email-michal.simek@xilinx.com>
	(Michal Simek's message of "Mon, 11 Feb 2013 19:04:34 +0100")
Message-ID: <87bobkqlnp.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <michal.simek@xilinx.com> writes:

 Michal> Use big and little endian accessors function to reflect system
 Michal> configuration.  Detection is done via control register in
 Michal> ulite_request_port.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
