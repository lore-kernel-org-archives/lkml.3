Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710Ab3BGW3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:29:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3BGW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:29:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 01/11] mei: bus: Initial MEI bus type implementation
Date: Thu, 7 Feb 2013 22:29:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072229.17591.arnd@arndb.de>
X-Provags-ID: V02:K0:gL+SPZ/mGPsX4qA11v2Lhl30yBPs+oimF1faJRent02
 T9nHyYMflLDWvi6dPxG8P1LabrYjk1uALkY1GliROXMVzAsz0j
 YxsITjhe9Jvgy9i/M+H7GjC3JElWU2alGlkMfpA1eL3WIq1bY1
 /JdHkBjWxH2Z1X5qtBYUNHStfY36DoGwKp9ZRncVEbWqFV2uMb
 m2EYh97Z/vWRhGqT+WJTaU09PpVyqabPzITt+Xk1NxA8tFaCk/
 C270J+mUXBmTlABGowAGqdndKceKm/5M+M6Lxk9iTY4RoMh3lz
 oDoAFuIbRUgnBYIaDzwPwUvVQfUVFTUs+wcbo5cn8vwyMXmiL3
 NcMA7xspBQIL/77z/WL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> mei bus will present some of the me clients
> as devices for other standard subsystems
> 
> Implement the probe, remove, match and the device addtion routines.
> A mei-bus.txt document describing the rationale and the API usage
> is also added.

This looks really nice, but I also think you have reached the point where
you are outgrowing the scope of drivers/misc. How about turning mei
into a top-level subsystem along with this new bus_type?

Another option would be moving it to drivers/bus/mei/ if you don't
want to be quite at the top.

	Arnd
