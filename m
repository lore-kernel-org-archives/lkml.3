Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3CKIcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:32:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41710 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab3CKIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:32:14 -0400
X-Sasl-enc: 0DlbXNnapC3HhjmGAsfZuk0JlZbIzB2hg/mJCePLjYm+ 1362990733
Message-ID: <513D968C.1060905@ladisch.de>
Date: Mon, 11 Mar 2013 09:32:12 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Helstroom <helstroom@google.com>
CC: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, damien@zamaudio.com,
        pete.leigh@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] Add a USB audio quirk for the NuForce UDH-100
 device.
References: <1362973920-4942-1-git-send-email-helstroom@google.com>
In-Reply-To: <1362973920-4942-1-git-send-email-helstroom@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Helstroom wrote:
> Interface 1 does not exist

Then it doesn't need a quirk, does it?

> and Interface 0 should be ignored.

Why?

If the driver doesn't like something in interface 0, that bug should be
fixed.

What is the output of "lsusb -v" for this device?


Regards,
Clemens
