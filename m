Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3GXGRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:17:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3GXGRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:17:09 -0400
Message-ID: <51EF7159.8030409@canonical.com>
Date: Wed, 24 Jul 2013 08:16:57 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Felipe Tonello <eu@felipetonello.com>, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, "Felipe F. Tonello" <ftonello@cercacor.com>,
        TakashiIwaitiwai@suse.de, linux-kernel@vger.kernel.org,
        JaroslavKyselaperex@perex.cz
Subject: Re: [alsa-devel] [PATCH] ALSA: SoC: Added jack detection kcontrol
 support
References: <1374281962-3786-1-git-send-email-eu@felipetonello.com> <20130722000157.GI9858@sirena.org.uk> <CAGrhNMyAofsnwKYMk+60GyvpaW9pMtoJf_2Q_Tc82G8QCFOiFA@mail.gmail.com> <20130723124023.GX9858@sirena.org.uk> <CAGrhNMyWXGcDUHxexgvQ2rusKTSbSjEbcEToKZZUudtP-pYxsA@mail.gmail.com> <20130724001332.GW9858@sirena.org.uk>
In-Reply-To: <20130724001332.GW9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 02:13 AM, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 05:10:29PM -0700, Felipe Tonello wrote:
>> On Tue, Jul 23, 2013 at 5:40 AM, Mark Brown <broonie@kernel.org> wrote:
>
>>> This was the existing kernel API at the time that the code was added -
>>> I beleive people had been doing that for simple switches that detect the
>>> physical presence of a jack since it looks exactly like a button from a
>>> hardware point of view.  See the original commit adding the code.
>
>> I saw it. I don't know what you think is the best way to go. I'm not
>> sure if someone is using this input event API, since even PulseAudio
>> even declined that implementation due KControl implementation.
>
> It's used quite a bit in embedded systems, there are actually patches
> for PulseAudio which were deployed for a while- I guess they might have
> been removed or something.

The input event implementation was only in Ubuntu (for a release or 
two), and was never merged in upstream PA. (I guess one could find them 
by looking in the Ubuntu archives.)

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
