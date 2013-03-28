Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3C1GON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:14:13 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53692 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3C1GOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:14:11 -0400
Date: Thu, 28 Mar 2013 00:14:36 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] ALSA: hda - Clean up documentation a bit
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1364373022.1390.331.camel@x61.thuisdomein>
In-Reply-To: <1364373022.1390.331.camel@x61.thuisdomein> (from
	pebolle@tiscali.nl on Wed Mar 27 03:30:22 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1364447676.18069.3@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 03:30:22 AM, Paul Bolle wrote:
> CONFIG_SND_HDA_POWER_SAVE was removed in v3.6.7, see commit
> 83012a7ccbb90dee33c97a004b3e374f988612af ("ALSA: hda - Clean up
> CONFIG_SND_HDA_POWER_SAVE"). Clean up hda's documentation to reflect
> that.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I send this to the sound maintainers. I guess this they need to  
> send
> it to the Documentation maintainer (after review).

No, it can go in via their tree. I'm more a librarian trying to keep  
the shelves in order, and some light copyediting on the side. I'm not a  
domain expert in everything, and thus can't _write_ most of this stuff.

Rob
