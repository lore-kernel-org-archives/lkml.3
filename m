Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaFXNL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:11:28 -0400
Received: from canardo.mork.no ([148.122.252.1]:58258 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbaFXNL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:11:26 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johan Hovold <johan@kernel.org>
Cc: Greg KH <greg@kroah.com>, Janne Kanniainen <janne.kanniainen@gmail.com>,
        jkosina@suse.cz, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Organization: m
References: <20140623161723.GA20421@kroah.com>
	<1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
	<20140623182324.GA30831@kroah.com> <20140623182432.GB30831@kroah.com>
	<20140623193134.GA15945@localhost> <20140623194059.GA19615@kroah.com>
	<20140623195212.GB15945@localhost> <20140623202448.GB29035@kroah.com>
	<20140623204430.GC15945@localhost>
Date: Tue, 24 Jun 2014 15:10:43 +0200
In-Reply-To: <20140623204430.GC15945@localhost> (Johan Hovold's message of
	"Mon, 23 Jun 2014 22:44:30 +0200")
Message-ID: <871tuewizw.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> This is a non-standard attribute of this particular laptop. It has three
> individual LEDs that can be enabled separately (using standard LED class
> attributes), but they will all three be in the same "mode" (which here
> apparently means that they can be fully on, vary with the volume(?!), or
> pulse synchronously when enabled).
>
> If we were to implement this mode attribute as a class attribute,
> changing the mode of of one LED would also change the mode of the other
> two devices (LEDs).

Document this behaviour and it becomes a feature.


Bjørn
