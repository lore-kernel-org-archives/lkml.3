Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3ANMyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:54:08 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58883 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3ANMyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:54:03 -0500
Message-ID: <50F3FFE6.4090108@suse.cz>
Date: Mon, 14 Jan 2013 13:53:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        daniel.vetter@ffwll.ch, David Airlie <airlied@linux.ie>
Subject: Re: -next: no resume from suspend
References: <50F3D9E8.6040802@suse.cz> <16191961.j5ydKsJ3d3@vostro.rjw.lan>
In-Reply-To: <16191961.j5ydKsJ3d3@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 01:56 PM, Rafael J. Wysocki wrote:
> On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
>> Hi,
>>
>> since friday's -next (the last known to be working is the last monday's)
>> I cannot resume from suspend. The last thing I see with
>> no_console_suspend is:
>> i915: No ACPI video bus found
>>
>> But I used to see the message always, so this is no difference. Any idea
>> before I start bisecting?
> 
> Well, what's the next message you normally see with no_console_suspend?

[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

Adding DRM and intel guys.

-- 
js
suse labs
