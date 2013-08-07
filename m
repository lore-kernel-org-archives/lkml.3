Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3HGKe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:34:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab3HGKe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:34:56 -0400
Date: Wed, 7 Aug 2013 12:34:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl, Aaron Lu <aaron.lu@intel.com>
Subject: Re: Backlight control only in the kernel?
Message-ID: <20130807103454.GC17920@pd.tnic>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <20130807074405.GA18272@pd.tnic>
 <52020D53.1030305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52020D53.1030305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 05:03:15PM +0800, Aaron Lu wrote:
> I think this would require the kernel has the knowledge of which
> backlight interface this system is using or should be using, or it
> wouldn't know which interface should receive and process the event...

Well, we can have a default one, say acpi_video and make it
overridable with command line options like acpi_backlight=vendor or
acpi_backlight=gpu, for example, if acpi_video suffers of a major
suckage...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
