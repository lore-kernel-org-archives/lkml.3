Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3L1WKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 17:10:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39992 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab3L1WKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 17:10:12 -0500
X-Sasl-enc: zDgcEmq5SHJ0ursAWMfUoA20oOuTLn1qvBhVzKB/04wO 1388268605
Date: Sat, 28 Dec 2013 20:10:03 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131228221003.GA24911@khazad-dum.debian.net>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <20131228211026.GA14725@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131228211026.GA14725@jak-x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Dec 2013, Julian Andres Klode wrote:
> On Mon, Nov 11, 2013 at 02:56:29PM +0100, Julian Andres Klode wrote:
> > This patch series adds support for specifying charging thresholds,
> > forcing a battery to discharge, and inhibiting charging, on ThinkPad
> > Laptops using Sandy Bridge or newer processors.
> 
> Hello again,
> 
> it's been about 1.5 months now after I submitted this patch series
> and I have not received any response yet.
> 
> I fixed the issues pointed out by Bjørn Mork in the previous patch
> except for the one with the battery names, as I have no idea how
> battery numbers are created or mapped. I can only say that the names
> are the same on my test machine, I don't have any other ones.
> 
> Henrique, it would be really great if you could take a look.

I did.  I just did not manage to finish looking over it, it is not really
okay as-is, mostly because it did not create a power-supply device and
properly extended that thing in a generic way, which would be vastly
preferable to adding yet another private interface.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
