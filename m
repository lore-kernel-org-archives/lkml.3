Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaELJOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:14:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaELJOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:14:44 -0400
Date: Mon, 12 May 2014 11:14:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, anssi.hannula@iki.fi,
        simon@mungewell.org
Subject: Re: [PATCH v4 00/24] input: Introduce ff-memless-next as an improved
 replacement for ff-memless
In-Reply-To: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
Message-ID: <alpine.LNX.2.00.1405121112520.5813@pobox.suse.cz>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2014, Michal Malý wrote:

> ff-memless-next (MLNX) is a largely improved version of the current ff-memless
> (FFML) driver. MLNX supports all force feedback effects currently available in
> the Linux force feedback userspace API. All effects are handled in accordance
> with Microsoft's DirectInput/XInput. Most notable changes include support for
> conditional effects, proper handling of all periodic waveforms and improved
> emulation of rumble effects through periodic effects. MLNX also uses its own
> kernel API to pass processed effects to hardware-specific drivers instead of
> abusing "ff_effect" struct. The API is documented in the respective header
> file.
> 
> MLNX has been expanded to be a direct replacement for FFML.
> 
> Support for FF_PERIODIC and FF_RAMP has been added to all devices that
> support FF_CONSTANT as a part of the port to the new API.
> 
> This patch series:
> 1) Adds "ff-memless-next" module [1]
> 2) Ports all hardware-specific drivers to MLNX's API [2-23]
> 3) Removes FFML and replaces it with MLNX [24]

Dmitry,

what are your plans with this, please?

I personally don't really completely like having two implementations of FF 
in the kernel; can't it be really done as an extension to ff-memless?

Thanks,

-- 
Jiri Kosina
SUSE Labs
