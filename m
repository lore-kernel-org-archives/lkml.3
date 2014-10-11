Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaJKUHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:07:14 -0400
Received: from bethyngalw.nowster.me.uk ([92.243.21.240]:33676 "EHLO
	bethyngalw.nowster.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:07:13 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2014 16:07:12 EDT
Date: Sat, 11 Oct 2014 20:51:08 +0100
From: Paul Martin <pm@debian.org>
To: Nix <nix@esperi.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141011195108.GA8275@thinkpad.nowster.org.uk>
References: <878um4tg09.fsf@spindle.srvr.nix>
 <1409569752.24385.12.camel@linux-fkkt.site>
 <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tqe2zqt.fsf_-_@spindle.srvr.nix>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having been privy to the firmware of the eKey, it is very simplisting,
with no implementation whatsoever of any flow control.

-- 
Paul Martin <pm@debian.org>
