Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3IQNDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:03:48 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63395 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3IQNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:03:46 -0400
Message-ID: <1379423017.2218.0.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH v2 1/3] backlight: introduce backlight_device_registered
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Tue, 17 Sep 2013 17:03:37 +0400
In-Reply-To: <1379409796-29350-2-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-2-git-send-email-aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> Introduce a new API for modules to query if a specific type of backlight
> device has been registered. This is useful for some backlight device
> provider module(e.g. ACPI video) to know if a native control
> interface(e.g. the interface created by i915) is available and then do
> things accordingly(e.g. avoid register its own on Win8 systems).
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> ---
>  drivers/video/backlight/backlight.c | 31 +++++++++++++++++++++++++++++++
>  include/linux/backlight.h           |  4 ++++
>  2 files changed, 35 insertions(+)

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.12.0-0.rc1.git0.1.fc20.x86_64

