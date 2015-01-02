Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbbABMF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 07:05:29 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55139 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbABMF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 07:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Fri, 2 Jan 2015 13:05:26 +0100
Message-ID: <CACna6rznUcqGTK0t1k=kjn0NVLycq865780ozyB+VYu78d_BSg@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: b43legacy: radio.c: Remove unused function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 January 2015 at 16:46, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function b43legacy_radio_set_tx_iq() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.

It seems to be for A-PHY based hardware (with 0x2060 radio id) which
is not handled by b43legacy. Should be safe to drop this code (we
won't likely need it).

Ack

-- 
Rafał
