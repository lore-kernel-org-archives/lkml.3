Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaBZVoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:44:37 -0500
Received: from canardo.mork.no ([148.122.252.1]:33570 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaBZVof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:44:35 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock Gigabit LAN
Organization: m
References: <87zjle6pif.fsf@nemi.mork.no>
	<20140226.154801.1466276966991949680.davem@davemloft.net>
	<87lhwx7f19.fsf@nemi.mork.no>
	<20140226.161659.2024676575146527914.davem@davemloft.net>
Date: Wed, 26 Feb 2014 22:44:18 +0100
In-Reply-To: <20140226.161659.2024676575146527914.davem@davemloft.net> (David
	Miller's message of "Wed, 26 Feb 2014 16:16:59 -0500 (EST)")
Message-ID: <87fvn57dn1.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Bjørn Mork <bjorn@mork.no>
>
>> No, sorry for being confusing.  The patch is fine.  But Keith sent it
>> first...
>
> Did I apply Keith's patch?

No, you didn't.  And when I went looking at it now, I see why: It was
posted to linux-usb and linux-kernel but not to netdev:
http://www.kernelhub.org/?msg=420289&p=2

> If not, should I apply it instead?

The patches are identical except for the author and a minor difference
in the device description string. 

It doesn't matter to me which patch you apply, and I absolutely don't
think it's my place to tell you which patches to apply or not :-)



Bjørn
