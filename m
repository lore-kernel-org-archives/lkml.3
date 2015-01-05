Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbbAETAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:00:18 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:52241
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbbAETAQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:00:16 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 14:00:16 EST
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/45] staging: comedi: fix up some driver comments
Thread-Topic: [PATCH 00/45] staging: comedi: fix up some driver comments
Thread-Index: AQHQKRDT9D4pGneoKUmf5ZXDV4qLYJyx2gHw
Date: Mon, 5 Jan 2015 18:55:14 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260B7633@P3PWEX4MB008.ex4.secureserver.net>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 05, 2015 10:54 AM, Ian Abbott wrote:
> Most comedi drivers have a special comedi driver comment block,
> information from which can be extracted by some scripts for use in the
> "Comedilib" manual and the list of supported devices on the comedi web
> site.  (Currently, the information for those places comes from the
> "out-of-tree" comedi drivers.)
>
> The "Devices:" line (and continuation lines) are supposed to be a
> comma-(and space)-separated list with the first item in this format:
>
>   [Manufacturer] BOARD-NAME (comedi-board-name)
>
> The "[Manufacturer]" and "(comedi-board-name)" parts can be omitted from
> subsequent list items to decrease verbosity, in which case they are
> assumed to be the same as the preceding item.
>
> Several comedi drivers have the "Devices:" line formatted incorrectly,
> often with the use of square brackets and parentheses reversed.  A few
> comedi modules have driver comments, but are just support modules for
> other drivers, so don't really need a driver comment.

Ian,

There are a number of drivers that still need the comedi comment block
converted to the normal CodingStyle format for multi-line comments.

And, as you mentioned to me before, all of the ADDI-DATA drivers
are missing the comedi comment block:

But, this is a great start to getting them cleaned up.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>


