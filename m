Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbaCTLOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:14:09 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57993 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932279AbaCTLOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:14:07 -0400
Message-ID: <532ACD7C.8050706@hurleysoftware.com>
Date: Thu, 20 Mar 2014 07:14:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gerd Grundke <gerdgrundke@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel bug: Mouse and keyboard dead when resuming from suspend
 on Lenovo W530
References: <532AA900.1010601@t-online.de>
In-Reply-To: <532AA900.1010601@t-online.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 04:38 AM, Gerd Grundke wrote:
> Dear all,
>
> after resuming from suspend, both mouse and keyboard are dead,
> there is no reaction whatsoever on any action, including the
> NUM-Lock leds and so on.

Please attach complete dmesg output, including the resume failure
if possible (eg., with ssh). System log is acceptable alternative
but please trim off other boot cycles.

Regards,
Peter Hurley

