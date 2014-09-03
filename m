Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaICR0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:26:49 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:36670
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbaICR0s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:26:48 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/37] staging: comedi: rename command flags for
 consistency
Thread-Topic: [PATCH 00/37] staging: comedi: rename command flags for
 consistency
Thread-Index: AQHPx3UMQ5vV2v1F40ujc0YCs8yIlpvvodsA
Date: Wed, 3 Sep 2014 17:26:13 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F8640B@P3PWEX4MB008.ex4.secureserver.net>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
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

On Wednesday, September 03, 2014 5:45 AM, Ian Abbott wrote:
>
> The various macros in "comedi.h" used to construct values for the
> `flags` member of `struct comedi_cmd` are named inconsistently.  Some of
> the macros with the `TRIG_` prefix are from a long defunct Comedi
> trigger interface that was replaced with the current Comedi asynchronous
> command interface many years ago, co-opting most of the `TRIG_` macros
> in the process.  Some of them are still used with various other members
> of `struct comedi_cmd` to select trigger sources.  Others are used with
> the `flags` member.  There are other macros for use with the command
> `flags` member using the prefix `CMDF_`, and some of the old `TRIG_`
> macros have been renamed already, keeping the old names around as
> synonyms for backwards compatibility.
>
> For consistency, rename the `TRIG_` prefixed macros used with the
> command `flags` member to use the prefix `CMDF_` and redefine the
> renamed macros as synonyms for backwards compatibilty.
>
> There are still some left-over `TRIG_` macros unused by the Comedi
> kernel code, but the user-space Comedilib library may still be trying to
> use them, so hang onto them for now.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

