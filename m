Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab3BKUTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:19:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936Ab3BKUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:18:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 2/2] tty: serial: uartlite: Support uartlite on big and little endian systems
Date: Mon, 11 Feb 2013 20:18:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, monstr@monstr.eu,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
References: <1360605874-18310-1-git-send-email-michal.simek@xilinx.com> <1360605874-18310-2-git-send-email-michal.simek@xilinx.com>
In-Reply-To: <1360605874-18310-2-git-send-email-michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302112018.35706.arnd@arndb.de>
X-Provags-ID: V02:K0:t7qg52oIJmDyQUpxc8b2EfMOMHhcRV2nXgzvgvuCXhw
 V2is85rD3cs+dimZ5n+naV5Ow5whHGt7Oenv5xIgak4l47fFXB
 +/bdB1X1EWJtVGoaGSLQ5fr9VhkB14AT1mUm0AK30JfhPJOSVR
 IChOYOX/n0AgkX/8WBZSk5po4JVEMwXdWuP9ntk20JS89xpXq0
 KTLFJ4rKYwh+b5C/uXg3XvfbNW61XGWSdAF454RgTaswktfb6T
 10ihYlwnDUdlvzRAfSZSmyzmT8Wjx9gmyzI/a/2/b8Oforu8Vt
 c1C+msGnvDQ8ws/oPz/9EpzjGP0BYv8zleHvVtnsc9qt3zUsr8
 Qw0KrIu2QZX0Oa27IIRM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Michal Simek wrote:
> 
> Use big and little endian accessors function to reflect system configuration.
> Detection is done via control register in ulite_request_port.
> 
> Tested on Microblaze LE, BE, PPC440 and Arm zynq.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
