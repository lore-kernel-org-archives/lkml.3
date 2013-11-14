Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3KNNwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:52:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3KNNwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:52:24 -0500
Date: Thu, 14 Nov 2013 13:52:09 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andreas Werner <wernerandy@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT
 signature)
Message-ID: <20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
In-Reply-To: <20131113183418.GA1593@thinkpad.fritz.box>
References: <20131113183418.GA1593@thinkpad.fritz.box>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My question now is, is it a bug in the driver or in the VGA Bios?
> 
> I´ve checked the VGA bios and did a hex dump but there is really no "$VBT" string.
> On an Atom Gen1 CPU with intel GMA500 Graphic there is the string in the VGA BIOS.
> But if i create the VGA BIOS for intel Atom E680 which has a GMA600 Graphic
> there is no string.
> 
> Does anybody of you running the GMA500 driver with and Atom E680 without having this
> problem? Or does anybody know how to get this string into the VGA BIOS?

E680 I believe will try and use the other style of parsing. I never got
my hands on one to confirm that but in general E6xx seems to use
Moorestown style tables instead and you'll only get support for some
outputs.

