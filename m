Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaJLLGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:06:07 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:47493 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaJLLGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <543A36A0.8090300@broadcom.com>
References: <1413071551-15372-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <543A36A0.8090300@broadcom.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 12 Oct 2014 13:05:40 +0200
Message-ID: <CAFo99gY9dyzhuJe4LwiJKgRwLRU+uVKzLpscFrZw_xZDhVKEWA@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: brcm80211: brcmfmac: dhd_sdio.c: Cleaning
 up missing null-terminate in conjunction with strncpy
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Daniel Kim <dekim@broadcom.com>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-12 10:06 GMT+02:00 Arend van Spriel <arend@broadcom.com>:
> On 12-10-14 01:52, Rickard Strandqvist wrote:
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>> And changed from using strncpy to strlcpy to simplify code.
>
> Looks good to me. Just two small process related remarks:
>
> - It is sufficient to prefix the patch with brcmfmac (skip net:...).
> - Send the patch to the wireless maintainer, ie. John Linville.

Hi

Sure, no problem.
Sending a new patch in a moment...

Kind regards
Rickard Strandqvist
