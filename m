Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3GQMN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:13:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33486 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3GQMN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <s5h61w9v1z6.wl%tiwai@suse.de>
References: <20130717101742.GA10433@fpirisp.portsdebalears.com>
 <s5hehaxv5os.wl%tiwai@suse.de> <20130717104751.GA9654@fpirisp.portsdebalears.com>
 <s5h61w9v1z6.wl%tiwai@suse.de>
From: Kiko Piris <kiko@pirispons.net>
Date: Wed, 17 Jul 2013 14:13:37 +0200
Message-ID: <CAAsRbJCmhR6BE2pcWQ7f7b4=3hdYud=1Q7BgkbC85M+p6eo-iw@mail.gmail.com>
Subject: Re: High pitched noise with snd_hda_intel since linux-3.9.0
To: Takashi Iwai <tiwai@suse.de>
Cc: Kiko Piris <kernel@pirispons.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 1:51 PM, Takashi Iwai <tiwai@suse.de> wrote:

> Looks like CONFIG_SND_HDA_CODEC_ANALOG=y is missing.

That was it!!

At last I’ve got sound again!

Thank you very much for your help! Much appreciated.

Cheers!

--
Kiko
