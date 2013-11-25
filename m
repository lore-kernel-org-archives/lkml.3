Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3KYVA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:00:28 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43429 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575Ab3KYVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:00:26 -0500
Message-ID: <5293BA67.3010405@hurleysoftware.com>
Date: Mon, 25 Nov 2013 16:00:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next 0/4] fwserial changes for 3.14
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com> <20131125204336.GA646@kroah.com>
In-Reply-To: <20131125204336.GA646@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 03:43 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 22, 2013 at 01:06:07PM -0500, Peter Hurley wrote:
>> **This patchset requires 'Halve tty buffer memory consumption' patchset **
>
> Requires it to build or just work properly?
>
> I'm trying to figure out what tree to take this in, (tty-next or
> staging-next).

To build.

The 'Halve tty buffer memory consumption' patchset exports new
methods that allow the driver to configure the maximum memory
consumption by the tty buffers.

This fwserial patchset uses that new interface to rely on tty
buffers to provide adequate rx buffering, rather than add'l rx
buffering being done by the driver.

By halving the buffer memory consumption, I don't feel so
guilty about doubling the limit :)

Regards,
Peter Hurley
