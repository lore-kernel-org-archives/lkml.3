Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3KSVeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:34:24 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44397 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812Ab3KSVeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:34:22 -0500
Message-ID: <528BD95B.3070400@hurleysoftware.com>
Date: Tue, 19 Nov 2013 16:34:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Heorhi Valakhanovich <valahanovich@tut.by>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Only hangup once
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com> <20131117203850.46df2124@tormoz-pc> <20131118134211.17861db3@alan.etchedpixels.co.uk> <528A5043.6030901@hurleysoftware.com> <528A797B.6020807@hurleysoftware.com> <20131119000923.5ca40e51@tormoz-pc> <528B6BB3.7020303@hurleysoftware.com> <20131119201952.2d63b8ce@tormoz-pc> <20131119174032.GB22604@kroah.com>
In-Reply-To: <20131119174032.GB22604@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 12:40 PM, Greg KH wrote:
> It should be backported to 3.12, and any other kernels?

Greg,

This patch should apply cleanly to 3.12.

The first commit to rely on the correct TTY_HUPPED state was
commit 36697529b5bbe36911e39a6309e7a7c9250d280a,
    'tty: Replace ldisc locking with ldisc_sem'
which was introduced in the 3.12 cycle.

Regards,
Peter Hurley

PS - Did you receive 'n_tty: Fix echo overrun tail computation'?
I saw it didn't make 3.12.1.

