Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3A2SHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:07:17 -0500
Received: from canardo.mork.no ([148.122.252.1]:43669 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab3A2SHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:07:14 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Dan Williams <dcbw@redhat.com>
Cc: Daniele Palmas <dnlplm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: option: add support for Telit LE920
Organization: m
References: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
	<1359479958.1635.8.camel@dcbw.foobar.com>
Date: Tue, 29 Jan 2013 18:26:12 +0100
In-Reply-To: <1359479958.1635.8.camel@dcbw.foobar.com> (Dan Williams's message
	of "Tue, 29 Jan 2013 11:19:18 -0600")
Message-ID: <871ud3q4sr.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dcbw@redhat.com> writes:
> On Mon, 2013-01-28 at 16:47 +0100, Daniele Palmas wrote:
>> From: danielepa <danielepa@L2011.(none)>
>> 
>> Add PID and special handling for Telit LE920
>
> Any idea what interfaces 1 and 5 are?  Is one perhaps a pseudo-ethernet
> interface that could be used instead of PPP?  What's the lsusb -v output
> for the device?

Daniele has already posted a patch adding intf #5 to qmi_wwan, so I
assume that is verified to be a QMI/rmnet interface.

But I was wondering about #1 too, if that indeed is a vendor specific
interface providing a non-serial, non-rmnet function.  What could that
be?


Bjørn
