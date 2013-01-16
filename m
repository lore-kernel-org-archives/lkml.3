Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3APKgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:36:12 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40110 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892Ab3APKgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:36:10 -0500
Message-ID: <50F68295.3@suse.cz>
Date: Wed, 16 Jan 2013 11:36:05 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, daniel.vetter@ffwll.ch,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: -next: no resume from suspend
References: <50F3D9E8.6040802@suse.cz> <16191961.j5ydKsJ3d3@vostro.rjw.lan> <50F3FFE6.4090108@suse.cz> <87fw21wkk4.fsf@intel.com>
In-Reply-To: <87fw21wkk4.fsf@intel.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 10:20 AM, Jani Nikula wrote:
> Hi Jiri, the dmesgs for both cases with drm.debug=0xe module param might
> give us some clues.
> 
> Does it work without no_console_suspend?

Hi, no, it does not work either way. But what I found out with debug
enabled, that it's a completely different problem: in ACPI. The kernel
is spinning acpi_rs_get_aml_length. I'll report details without CCing
DRM people.

thanks,
-- 
js
suse labs
