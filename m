Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKCJTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:19:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaKCJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:19:35 -0500
Date: Mon, 3 Nov 2014 10:19:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Pr=E9dhomme_Philippe?= <predhomme.p@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PATCH : add support for HuiJia USB Gamepad connector (0e8f:1006
 and 0e8f:3010)
In-Reply-To: <54548792.3000206@gmail.com>
Message-ID: <alpine.LNX.2.00.1411031019040.19451@pobox.suse.cz>
References: <CAC9ZNDJiZzmBr-NKWjaxVZwCyO65F00WMEaVB=OwsTznJCBUOA@mail.gmail.com> <54548792.3000206@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Prédhomme Philippe wrote:

> Create each gamepad as a separate joystick.
> Both device (1006 is for Sega Saturn controllers, 3010 is for Sony
> Playstation 1/2 controllers) work the same as 0e8f:3013 (which is for
> Nintendo 64 controllers), so i used this device as reference to make my
> patch.
> Work with kernel 3.14, 3.15, 3.16, 3.17.
> I hope i was finally able do disable line-wrapping...

Unfortunately it's still broken.

Please consult

	Documentation/email-clients.txt

for help, and resend.

Thanks,

-- 
Jiri Kosina
SUSE Labs
