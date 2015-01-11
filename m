Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbbAKXAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:00:46 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:42267 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbbAKXAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:00:45 -0500
Date: Mon, 12 Jan 2015 00:58:02 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Darren Hart <dvhart@infradead.org>, Andy Lutomirski <luto@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
Message-ID: <20150111225802.GA12944@node.dhcp.inet.fi>
References: <20141218175126.GA78864@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218175126.GA78864@vmdeb7>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
> thinkpad-acpi using software mute simplifies the driver and the user experience
> significantly.

Except when it doesn't.

I'm probably in minority, but I don't use fancy userspace to mess with my
mixer and the mute button worked just fine for me before the change.
Wasted half an hour to find out what happened is not a pure win from user
experience point of view.

Is it really necessary to have software_mute_requested == true by default?
Can fancy userspace ask for desired behaviour instead and change kernel to
not send hotkeys change notification until software_mute is enabled?

-- 
 Kirill A. Shutemov
