Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaGWUEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:04:12 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:61589 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaGWUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:04:11 -0400
MIME-Version: 1.0
Date: Wed, 23 Jul 2014 16:04:07 -0400
Message-ID: <CAPDOMVjrFzrveTuYeZQ1o7XEYP_pcmF0Z9b2_Y9eGVidvzy+ig@mail.gmail.com>
Subject: staging: Unwritten function for ion_carveout_heap.c
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: john.stultz@linaro.org, ccross@android.com, rebecca@android.com,
        Laura Abbott <lauraa@codeaurora.org>, gioh.kim@lge.com,
        benjamin.gaignard@linaro.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg and others.
Sorry for another email but it seems the function,
ion_carveout_heap_unmap_dma is
just returning and not doing anything useful. Furthermore I am new so
I don't known how
to write this function but this may  be causing  some rather  serious
bugs as if the dma heap
is not unmaped and we  call this function a lot this will make the
kernel not able to handle dma requests
for this driver and other drivers that need this and in turn lead to
a oops or even a kernel panic due to leaked
dma allocated memory. I would recommend writing this function or
helping me write it in
other to avoid some rather serious bugs without a proper dma unmapping
function for this driver  :).
Nick
