Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaKKXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:16:36 -0500
Received: from mout.gmx.com ([74.208.4.200]:56422 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaKKXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:16:35 -0500
MIME-Version: 1.0
Message-ID: <trinity-9deba5f6-773b-4e0f-8a3f-b1df2e351d03-1415747793609@3capp-mailcom-lxa04>
From: "Chateau DuBlanc" <chateaudublanc@post.com>
To: linux-kernel@vger.kernel.org
Subject: Re: <PulseAudio>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Nov 2014 00:16:34 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:qDZr9Yv6sqwmkQ+kI9LLAN0SAZKuv+2RmOQ0IP5t5es
 uQ7xLur4OWDsGRiakTQxsG0NJvKQVAZnK8xEvFHr7R5XVgnOH7
 Cdkl7NKphxXi7LtvQMSJJwAv08LWIZds7cUvB2zQW3Jl1tBM1q
 2I4FLKffahsnyL0Syfv5mZqvoFay3sDmSfvDiFM1CcCIeL2K6P
 GP/43KrSHWn/SkBUHSh16DlrAGjlldrbenDAyljXXMCzsCNPXl
 3DQNqk5PGNseTTBZp2KaIc8p4UdPhgkZI9gHTlAag7J+dIrj2q
 Oicwnkn4bDhj2rBTp4D87WlUMXR
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I appreciate you work over the years making pulseaudio not a piece of shit.
Poettering is like a leaf blowing in the wind with an attention span measured in
dog years.

For my main systems I use pure alsa. Everything needed can and is done through it
and it's config files (yes they're complex, but that's the workflow I prefer on
systems I want to have tight control over). When I need to record alsa is where it is at.
It is easy to use alsa config to combine multiple sound cards into one many channel
virtual sound card and record (conncurrently multitrack) using that.

(Though I prefer to use one of the real non-computer multitrack recording devices)

Pulseaudio, well it's fine on fire-and-forget systems I just install to be non-productive
desktops. It has pauvcontrol, an easy gui for when I don't want to be bothered.

That's its value.
Alsa if better for everything else.

Anyway, thanks for fixing what broke linux audio forever. I'm sure that was a long hard
and thankless job. Someone made a mess, was incompetent, and you said "finally he's gone
not to fix this shit and make it work like it promised to".

Thanks for that.
(Note: as I said before, on important machines I don't run pulse audio or other always-on
daemons: the kernel is a security nightmare as is, don't need more of the same type of
complex code always running on security-neccesary systems.)

> Sent: Tuesday, November 11, 2014 at 9:41 PM
> From: "Luke Yelavich" <themuso@ubuntu.com>
> To: ubuntu-devel-discuss@lists.ubuntu.com
> Subject: Re: <PulseAudio>
>
> On Sun, Sep 28, 2014 at 03:05:57AM AEST, Nomen Nescio wrote:
> > 2014-03-03 PulseAudio 5.0 has been released
> > 
> > http://www.freedesktop.org/wiki/Software/PulseAudio
> 
> This is known, however we have some very tight integration with PulseAudio, both for the Desktop and the phone, and updating all the integrated components in lockstep takes time.
> 
> Chances are vivid will have PulseAudio 5.0 or even 6.0, but I cannot promise anything at this stage.
> 
> Luke
> 
> -- 
> Ubuntu-devel-discuss mailing list
> Ubuntu-devel-discuss@lists.ubuntu.com
> Modify settings or unsubscribe at: https://lists.ubuntu.com/mailman/listinfo/ubuntu-devel-discuss
> 
