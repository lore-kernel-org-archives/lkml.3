Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3GBUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:31:24 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:46587 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755588Ab3GBUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:31:20 -0400
Message-ID: <51D33895.1030000@hurleysoftware.com>
Date: Tue, 02 Jul 2013 16:31:17 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: Re: [PATCH] kernel panic, pty.c: remove direct call to tty_wakup
 in pty_write with better commit message
References: <51D196EA.7010809@gmail.com> <51D32303.2060904@hurleysoftware.com> <51D3365B.5010503@gmail.com>
In-Reply-To: <51D3365B.5010503@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 04:21 PM, Andre Naujoks wrote:
> Thanks for the pointer. Since your patch is from April, does that mean, that we cannot expect it to hit 3.11?

Yes, that patch was scheduled for 3.12.
But a patch with a revised commit message detailing a bug fix
could definitely go into 3.11 (which is why I suggested adding
a detailed commit message explaining the bug fix).

Regards,
Peter Hurley

