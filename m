Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3IKXTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:19:00 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33305 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422Ab3IKXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:18:58 -0400
Message-ID: <5230FA5D.9020607@hurleysoftware.com>
Date: Wed, 11 Sep 2013 19:18:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jon Bernard <jbernard@tuxion.com>
CC: gregkh@linuxfoundation.org, stefanr@s5r6.in-berlin.de, jslaby@suse.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: fwserial: wrap a line that exceeds 80 characters
References: <1378850401-23402-1-git-send-email-jbernard@tuxion.com>
In-Reply-To: <1378850401-23402-1-git-send-email-jbernard@tuxion.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 06:00 PM, Jon Bernard wrote:
> This is a patch to fwserial.c that wraps a line which previously exceeded the 80
> character limit warning found by checkpatch.pl.  This driver is now warning and
> error free, according to checkpatch.pl
>
> Signed-off-by: Jon Bernard <jbernard@tuxion.com>

Ok with me, thanks.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

