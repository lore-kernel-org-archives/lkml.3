Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaG3Wma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:42:30 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:54584 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaG3Wm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <53D947F3.6010301@canonical.com>
References: <53D947F3.6010301@canonical.com>
Date: Wed, 30 Jul 2014 15:42:27 -0700
X-Google-Sender-Auth: 0hlZ83peSTzVaMJNr9XeMEHnOHs
Message-ID: <CAODwPW-tf0D70v5La1z+-jo5rgKFW_Q2fMCZGWZkf0DnyTUuTA@mail.gmail.com>
Subject: Re: [REVERT][v3.16-rc7][STABLE] usb: xhci: Prefer endpoint context
 dequeue pointer over stopped_trb
From: Julius Werner <jwerner@chromium.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Julius Werner <jwerner@chromium.org>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dustin Kirkland <dustin.kirkland@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

> Julius, I was hoping to get your feedback, since you are the patch
> author.  Do you think gathering any additional data will help diagnose
> this issue, or would it be best to continue with this revert request?

As I understand it, this crash will disappear with Mathias' new rework
for finding the cycle state bit in
http://www.spinics.net/lists/linux-usb/msg111259.html , so a revert
should not be necessary.
