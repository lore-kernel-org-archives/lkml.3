Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbaKMWPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:15:15 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:54500 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaKMWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1411131710200.4266-100000@iolanthe.rowland.org>
References: <CANLzEktsBvmX7Nbn=+JBq6A=cowqnFVPJ1ymQjbv4dgrDvSLFA@mail.gmail.com>
	<Pine.LNX.4.44L0.1411131710200.4266-100000@iolanthe.rowland.org>
Date: Thu, 13 Nov 2014 14:15:11 -0800
X-Google-Sender-Auth: C3ifeRdkrIcfM4pJEMPFzUdXbW4
Message-ID: <CANLzEksHgo_tQiwJoUtXd0iV7tDXq0ieNrAXgtXwPtxxPBWrgw@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Benson Leung <bleung@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Nov 13, 2014 at 2:11 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Wait a minute -- in your previous email you said this approach didn't
> work.  So does it work or doesn't it?

Sorry for the confusion. The approach *does* work.

That was actually my original idea to fix the problem, but I saw other
places in the kernel where it was done with a get/put.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
