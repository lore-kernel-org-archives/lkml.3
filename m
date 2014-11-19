Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaKSSMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:12:54 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:40132 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaKSSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:12:52 -0500
Date: Wed, 19 Nov 2014 10:12:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marcus Overhagen <marcus.overhagen@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Ulrik De Bie <ulrik.debie-os@e2big.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [git pull] Input updates for 3.18-rc4
Message-ID: <20141119181247.GE37989@dtor-ws>
References: <20141114222640.GA39748@dtor-ws>
 <CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
 <CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

On Wed, Nov 19, 2014 at 07:00:16PM +0100, Marcus Overhagen wrote:
> I'm not sure if my problems are related, but anyway:
> 
> I'm using a Samsung NP730U3E notebook that also has an elantech touchpad.
> 
> With 3.18.0-rc3 two finger scrolling in Firefox is smoth, but with
> 3.18.0-rc5 I have to press a
> lot harder and usually scrolling only startes after stopping the
> movement shortly and retrying once
> 
> I skipped rc4.
> 
> from RC3 dmesg:
> [   20.507633] psmouse serio1: elantech: assuming hardware version 4
> (with firmware version 0x675f04)
> [   20.520740] psmouse serio1: elantech: Synaptics capabilities query
> result 0x10, 0x15, 0x0e.
> 

Can you try reverting caeb0d37fa3e387eb0dd22e5d497523c002033d1 please?
The rest should have no effect on you.

Thanks.

-- 
Dmitry
