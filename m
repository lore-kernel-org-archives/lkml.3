Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3CIVtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 16:49:31 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49514 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CIVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 16:49:30 -0500
Message-ID: <513BACAC.9050800@gmail.com>
Date: Sat, 09 Mar 2013 23:42:04 +0200
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: Screen turns off when booting in EFI mode
References: <kg69ef$vdb$1@ger.gmane.org> <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com> <5126C3E1.80801@gmail.com>
In-Reply-To: <5126C3E1.80801@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-22 03:03, Mantas Mikulėnas wrote:
> On 2013-02-22 01:54, Dave Airlie wrote:
>>>
>>> | radeon 0000:01:00.0: No connectors reported connected with modes
>>> | [drm] Cannot find any crtc or sizes - going 1024x768
>>>
>>> The connector is definitely connected, since this is a laptop with a
>>> built-in screen...
>>>
>>
>> Can you get the log with drm.debug=6 from both boots as well?
> 
> Attached.

The log is also at http://nullroute.eu.org/tmp/2013/dmesg-drm-debug.txt

Not to be annoying, but I hope this can be fixed until 3.9...

(I just tested v3.9-rc1-278-g8343bce, and it still does not detect any
displays. And if I understood it correctly, "nomodeset" is going to go
away?)

-- 
Mantas Mikulėnas <grawity@gmail.com>
