Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbbAFSTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:19:55 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56477 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbAFSTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:19:53 -0500
MIME-Version: 1.0
In-Reply-To: <1420567175-17323-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420567175-17323-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 6 Jan 2015 19:19:52 +0100
Message-ID: <CACna6ryS_+eYi3ODXMngCxwoe8JLuWQyaCNNmhJFHM+g7H_Xzw@mail.gmail.com>
Subject: Re: [PATCH] b43legacy: Remove unused function
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

On 6 January 2015 at 18:59, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function b43legacy_radio_set_tx_iq() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Rafał Miłecki <zajec5@gmail.com>
