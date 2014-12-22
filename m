Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaLVHee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:34:34 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:51333 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaLVHed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <1419201796-13790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419201796-13790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 22 Dec 2014 07:34:32 +0000
Message-ID: <CAJSP0QXsXqfJCMMGgixyryVCX7isQHf=9rhyCwfiOgP5TFYRsg@mail.gmail.com>
Subject: Re: [PATCH] staging: line6: toneport.c: Fix for possible null pointer dereference
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerry Snitselaar <dev@snitselaar.org>,
        Fabian Mewes <architekt@coding4coffee.org>, devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:43 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> The NULL check was done to late, and there it was a risk
> of a possible null pointer dereference.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/line6/toneport.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
